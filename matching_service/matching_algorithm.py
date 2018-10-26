import random

request_example = {
   "start_location": { "lat": 12.0, "lng": 53.4}, #random point, change it to something better
   "end_location":{ "lat": 12.0, "lng": 53.4}
}
group_example = {
   "id": "q2no43tn3o4itq3o4itq34oitj",
   "name": "a_group",
   "path": "an encoded path following this specification: https://pypi.org/project/polyline/"
}
def match(request, group):
   return random.randint(0,1001)