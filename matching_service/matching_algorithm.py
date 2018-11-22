import random
import polyline
from geopy.distance import geodesic

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
   decoded_poly = polyline.decode(group["path"])

   start = (request["start_location"]["lat"],request["start_location"]["lng"])
   end = (request["end_location"]["lat"],request["end_location"]["lng"])

   start_start_dist = geodesic(start,decoded_poly[0]).miles
   end_end_dist = geodesic(end,decoded_poly[-1]).miles
   return start_start_dist+ end_end_dist