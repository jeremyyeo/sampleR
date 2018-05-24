# exrater

Retrieving exchange rates from the ECB.

http://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/index.en.html

## Get Current Rates

```
curl -O http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml
```

## Get Historical Rates (last 90 days)

```
curl -O http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml
```

## Get Historical Rates (last 90 days)

```
curl -O http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist.xml 
```