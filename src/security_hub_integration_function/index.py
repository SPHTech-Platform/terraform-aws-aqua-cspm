import json
import boto3
import os
import logging
import urllib3.request
import hashlib
import time
import hmac
import base64

LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)
sess = boto3.session.Session()
sm_client = sess.client('secretsmanager')

def lambda_handler(event, ctxt):
    LOGGER.info('Lambda started :{}'.format(event))
    aqua_url = 'https://asia-1.api.cloudsploit.com'
    resData = {}
    rp = event['ResourceProperties']
    secret = rp['Secret']
    try:
        conf = get_conf(secret)
        aqua_api_key = conf['aqua_api_key']
        aqua_secret = conf['aqua_secret']
    except Exception as e:
        LOGGER.error('Error retrieving Keys: {e}')
        failRetKey = {'status': 'FAILED', 'message': 'Error retrieving Keys'}
        return failRetKey
    if event['LogicalResourceId'] == 'ExternalIDInvoke':
        LOGGER.info('ExtID creation started :{}'.format(event))
        try:
            extid = get_ext_id(aqua_url, aqua_api_key, aqua_secret)
            sucExtID = {'status': 'SUCCESS', 'ExternalId': extid}
            return sucExtID
        except Exception as e:
            LOGGER.error(e)
            failExtID = {'status': 'FAILED', 'message': str(e)}
            return failExtID
    elif event['LogicalResourceId'] == 'IntegrationInvoke':
        LOGGER.info('Started integrating :{}'.format(event))
        extid = rp['ExtId']
        region = rp['Region']
        role_arn = rp['RoleArn']
        notifications = rp['ScanNotifications']
        acc = rp['AccId']
        intData = {}
        try:
            integrate(aqua_url, aqua_api_key, aqua_secret, acc, role_arn, extid, region, notifications)
            LOGGER.info(f'Integration successful {acc}')
            sucMsg = {'status': 'SUCCESS', 'AccountId': acc, 'Integrating': True}
            return sucMsg
        except Exception as e:
            LOGGER.error(e)
            errMsg = {'status': 'FAILED', 'message': str(e)}
            return errMsg

def get_conf(secret):
    val = sm_client.get_secret_value(SecretId=secret)
    resp = val['SecretString']
    return json.loads(resp)

def get_ext_id(url, api_key, aqua_secret):
    path = "/v2/generatedids"
    method = "POST"
    tstmp = str(int(time.time() * 1000))
    enc = tstmp + method + path
    enc_b = bytes(enc, 'utf-8')
    secret = bytes(aqua_secret, 'utf-8')
    sig = hmac.new(secret, enc_b, hashlib.sha256).hexdigest()
    hdr = {
        "Accept": "application/json",
        "X-API-Key": api_key,
        "X-Signature": sig,
        "X-Timestamp": tstmp,
        "content-type": "application/json"
    }
    http = urllib3.PoolManager()
    req = http.request('POST', url + path, headers=hdr)
    res = json.loads(req.data.decode('utf-8'))
    return res['data'][0]['generated_id']

def integrate(url, api_key, aqua_secret, acc, role, ext_id, region, notificationType):
    path = "/v2/integrations"
    method = "POST"
    tstmp = str(int(time.time() * 1000))
    body = {
        "enabled": True,
        "name": "security_hub_" + acc,
        "settings": {
        "role_arn": role,
        "external_id": ext_id,
        "product_arn": "arn:aws:securityhub:" + region + "::product/aquasecurity/aquasecurity"
        },     
        "type": "securityhub"
    }
    if notificationType == 'Send New Risks Only':
        body['send_new_risks'] = True
    else:
        body['send_scan_results'] = True
    body_str = json.dumps(body, separators=(',', ':'))
    LOGGER.info(body_str)
    enc = tstmp + method + path + body_str
    enc_b = bytes(enc, 'utf-8')
    secret = bytes(aqua_secret, 'utf-8')
    sig = hmac.new(secret, enc_b, hashlib.sha256).hexdigest()
    hdr = {
        "Accept": "application/json",
        "X-API-Key": api_key,
        "X-Signature": sig,
        "X-Timestamp": tstmp,
        "content-type": "application/json"
    }
    http = urllib3.PoolManager()
    req = http.request('POST', url + path, headers=hdr, body=body_str)
    res = req.data
    LOGGER.info(f'Registration: {res}')
