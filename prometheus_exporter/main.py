# source of inspiration: https://www.twilio.com/blog/asynchronous-http-requests-in-python-with-aiohttp

import asyncio
from aiohttp import ClientSession
import pandas as pd
import json

from api_calls import get_available_metrics, get_monitoring_metric

PROMETHEUS_QUERY_ROOT: str = 'http://localhost:9090/api/v1/query'

prometheus_query_urls: list[str] = [
    'query=netdata_cpu_cpu_percentage_average&range_input=1h',
    # 'query=status',
    # 'query=up'

]


def get_urls() -> list[str]:

    urls: list[str] = [
        f'{PROMETHEUS_QUERY_ROOT}?{query_url}' for query_url in prometheus_query_urls]

    return urls


async def main():

    async with ClientSession() as session:
        tasks: list[asyncio.Task] = list()
        monitoring_urls: list[str] = get_urls()

        all_metrics = asyncio.ensure_future(get_available_metrics(session))

        for monitoring_endpoint in monitoring_urls:
            tasks.append(asyncio.ensure_future(
                get_monitoring_metric(session, monitoring_endpoint)))

        all_monitoring_metrics = await all_metrics

        endpoint_responses = await asyncio.gather(*tasks)

        for endpoint in endpoint_responses:
            endpoint_results = endpoint['data']['result']

            for result in endpoint_results:
                print(json.dumps(result))

        # TODO combine to DF


asyncio.run(main())
