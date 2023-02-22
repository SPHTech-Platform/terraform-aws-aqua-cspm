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
    rp = event['ResourceProperties']
    secret = rp['Secret']
    try:
        conf = get_conf(secret)
        aqua_api_key = conf['aqua_api_key']
        aqua_secret = conf['aqua_secret']
    except Exception as e:
        LOGGER.error('Error retrieving Keys: {e}')
        return json.dumps({'status': 'FAILED', 'message': 'Error retrieving Keys'})

    if event['LogicalResourceId'] == 'ExternalIDInvoke':
        LOGGER.info('ExtID creation started :{}'.format(event))
        try:
            extid = get_ext_id(aqua_url, aqua_api_key, aqua_secret)
            resData = {'ExternalId': extid}
            return resData
        except Exception as e:
            LOGGER.error(e)
            return json.dumps({'status': 'FAILED', 'message': str(e)})

    elif event['LogicalResourceId'] == 'OnboardingInvoke':
        LOGGER.info('Onboarding started :{}'.format(event))
        extid = rp['ExtId']
        group = rp['Group']
        role_arn = rp['RoleArn']
        acc = rp['AccId']
        onbData = {}
        try:
            g_id = get_gid(aqua_url, aqua_api_key, aqua_secret, group)
            register(aqua_url, aqua_api_key, aqua_secret, acc, role_arn, extid, g_id)
            LOGGER.info(f'Account registered {acc}')
            onbData = {'AccountId': acc, 'Registered': True}
            return json.dumps({'status': 'SUCCESS', 'data': onbData})
        except Exception as e:
            LOGGER.error(e)
            return json.dumps({'status': 'FAILED', 'message': str(e)})


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


def get_gid(url, api_key, aqua_secret, group):
    path = "/v2/groups"
    method = "GET"
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
    req = http.request('GET', url + path, headers=hdr)
    res = json.loads(req.data.decode('utf-8'))
    for item in res['data']:
        if item['name'] == group:
            gid = item['id']
            LOGGER.info(f'Group ID: {gid}')
            return gid


def register(url, api_key, aqua_secret, acc, role, ext_id, gid):
    path = "/v2/keys"
    method = "POST"
    tstmp = str(int(time.time() * 1000))
    body = {
        "name": acc,
        "cloud": "aws",
        "role_arn": role,
        "external_id": ext_id,
        "group_id": gid
    }
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
