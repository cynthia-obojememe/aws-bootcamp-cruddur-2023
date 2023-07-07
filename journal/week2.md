# Week 2 — Distributed Tracing

## #1 HONEYCOMB SETUP
Create an account with Honeycomb via https://ui.honeycomb.io/


## Required Homework

```
- Observer and understanding of the use of Honeycomb, which is an application used for logging and tracing data. Also used OTEL-Open 
  Telemetry open source observability framework with Honeycomb to instrument traces and logs.
- Instrument Honeycomb for the fronted application to observe network latency between frontend and backend
- Add custom Instrumentation to honeycomb to add more attributes eg UserID and a custom span
- Run custom queries in Honeycomb and save them later eg latency by UserID


```

*** SETUP HONEYCOMB ENV on the environment

```
export HONEYCOMB_API_KEY=""
export HONEYCOMB_SERVICE_NAME="Cruddur"
```
- a. create opentelement (OTEL ENV)Honeycomb for the back-end on docker compose.yml
```
      OTEL_SERVICE_NAME: 'backend-flask'
      OTEL_EXPORTER_OTLP_ENDPOINT: "https://api.honeycomb.io"
      OTEL_EXPORTER_OTLP_HEADERS: "x-honeycomb-team=${HONEYCOMB_API_KEY}" 
````
- b. ADD The DEPENDENCES TO The requiremnt.txt for the opentelemetry installation
```
opentelemetry-api 
opentelemetry-sdk 
opentelemetry-exporter-otlp-proto-http 
opentelemetry-instrumentation-flask 
opentelemetry-instrumentation-requests

```

-- c. ADD to app.py

```
# Honeycomb ----
from opentelemetry import trace
from opentelemetry.instrumentation.flask import FlaskInstrumentor
from opentelemetry.instrumentation.requests import RequestsInstrumentor
from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor

# Initialize tracing and an exporter that can send data to Honeycomb
provider = TracerProvider()
processor = BatchSpanProcessor(OTLPSpanExporter())
provider.add_span_processor(processor)
trace.set_tracer_provider(provider)
tracer = trace.get_tracer(__name__)

app = Flask(__name__)
# Initialize automatic instrumentation with Flask
FlaskInstrumentor().instrument_app(app)
RequestsInstrumentor().instrument()

```


![HoneyComb output](assest/oneycomb.png)

```
from opentelemetry import trace


tracer = trace.get_tracer("home.activities")

       
class HomeActivities:
  def run():
    with tracer.start_as_current_span("home-activities-mock-data"):
 ```

## 
  ![Homework output](assest/honey%20traces.png)

## #2 AWS XRAY SETUP

-- To get started, Run the AWS xray via the terminal using the below command.
```
pip install aws-xray-sdk

AND add the above code to the backend requirement file
```

- add the x-ray middleware setup on `app.py`
```
# xray
from aws_xray_sdk.core import xray_recorder
from aws_xray_sdk.ext.flask.middleware import XRayMiddleware
xray_url = os.getenv("AWS_XRAY_URL")
xray_recorder.configure(service='Cruddur', dynamic_naming=xray_url)
XRayMiddleware(app, xray_recorder)
```

-- Create a Sampling Rule name 'Backend-flask'. This code is to be written in a new  `aws/json/xray.json` file
```
{
  "SamplingRule": {
      "RuleName": "Cruddur",
      "ResourceARN": "*",
      "Priority": 9000,
      "FixedRate": 0.1,
      "ReservoirSize": 5,
      "ServiceName": "Cruddur",
      "ServiceType": "*",
      "Host": "*",
      "HTTPMethod": "*",
      "URLPath": "*",
      "Version": 1
  }
}
```

-- Create a new group for tracing and analyzing errors and faults in a Flask application.
```
FLASK_ADDRESS="https://4567-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
aws xray create-group \
   --group-name "Cruddur" \
   --filter-expression "service(\"$FLASK_ADDRESS\")"
