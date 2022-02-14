'''
  Return STS credentials
'''

import boto3
import logging as log


def get_temporary_credentials(role_to_assume, region, session_name, duration_seconds=3600):
  '''
  Return temporary credentials
  '''

  log.info('Assuming role {} in region {} with session name {} for {} seconds'.format(
      role_to_assume, region, session_name, duration_seconds))

  sts_client = boto3.client('sts', region_name=region)
  assumed_role = sts_client.assume_role(RoleArn=role_to_assume,
                                        RoleSessionName=session_name,
                                        DurationSeconds=duration_seconds)

  return assumed_role['Credentials']