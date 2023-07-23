from aiohttp import ClientSession


async def get_monitoring_metric(session: ClientSession, monitoring_endpoint: str) -> dict:
    async with session.get(monitoring_endpoint) as response:
        monitoring_metric = await response.json()
        # TODO return as Python class or Pandas DF
        return monitoring_metric


async def get_available_metrics(
    session: ClientSession,
    url: str = 'http://localhost:9090'
) -> dict:
    async with session.get(f'{url}/api/v1/label/__name__/values') as response:
        return await response.json()
