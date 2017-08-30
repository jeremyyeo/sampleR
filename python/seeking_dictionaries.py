import pprint

REPORTS = [
    {
        'report_currency': 'NZD',
        'required_currency': 'NZD',
        'value': 5
    },
    {
        'report_currency': 'NZD',
        'required_currency': 'USD',
        'value': 5
    },
    {
        'report_currency': 'NZD',
        'required_currency': 'GBP',
        'value': 5
    }
]


EXCHANGE_RATES = {
    'NZD': {
        'USD': 0.5,
        'GBP': 0.2
    }
}

# Print before converting rates.
pprint.pprint(REPORTS)

for item in REPORTS:
    report_currency = item['report_currency']
    if item['required_currency'] in EXCHANGE_RATES[report_currency].keys():
        multiplier = EXCHANGE_RATES[report_currency][item['required_currency']]
        item['value'] = item['value'] * multiplier
        print('Report {} value updated.'.format(REPORTS.index(item)))
    else:
        print('Report {} value left as is.'.format(REPORTS.index(item)))


# Print after converting rates.
pprint.pprint(REPORTS)
