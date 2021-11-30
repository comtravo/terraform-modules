#!/usr/bin/env python
'''
  Wait for the ECS service to be stable
'''

import argparse
import boto3
import os
import sys
import time

ROOT_DIR = os.path.join(os.path.dirname(__file__), "../../../lib/")
sys.path.append(ROOT_DIR)

from assume_role import get_temporary_credentials


def parse_cli():
  '''
    parse cli
  '''
  parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter)
  parser.add_argument('--region', required=True, type=str, help='AWS region')
  parser.add_argument('--cluster', type=str, help='ECS service to check for stability', required=True)
  parser.add_argument('--service', type=str, help='ECS service to check for stability', required=True)
  parser.add_argument('--role_to_assume', type=str, help='AWS IAM role to assume', required=True)
  parser.add_argument('--service_stability_check_timeout',
                      type=int,
                      help='Maximum time to wait in seconds for the service to be stable',
                      required=True)
  parser.add_argument('--interval_between_stability_checks',
                      type=int,
                      help='Maximum time to wait in seconds for the service to be stable',
                      required=True)

  return parser.parse_args()


def get_ecs_client(args):
  '''
    Get ECS client
  '''
  credentials = get_temporary_credentials(role_to_assume=args.role_to_assume,
                                          region=args.region,
                                          session_name='{}-{}'.format(args.service, time.time()),
                                          duration_seconds=args.service_stability_check_timeout * 2)

  return boto3.client('ecs',
                      region_name=args.region,
                      aws_access_key_id=credentials["AccessKeyId"],
                      aws_secret_access_key=credentials["SecretAccessKey"],
                      aws_session_token=credentials["SessionToken"])


def wait_for_service_to_be_stable(ecs_client, args):
  '''
    Wait for service to be stable
  '''

  max_attempts = args.service_stability_check_timeout / args.interval_between_stability_checks

  waiter = ecs_client.get_waiter('services_stable')

  waiter.wait(cluster=args.cluster,
              services=[args.service],
              WaiterConfig={
                  'Delay': args.interval_between_stability_checks,
                  'MaxAttempts': max_attempts
              })


def main():
  args = parse_cli()
  ecs_client = get_ecs_client(args)
  wait_for_service_to_be_stable(ecs_client, args)


if __name__ == '__main__':
  main()
