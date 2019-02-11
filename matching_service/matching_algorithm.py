from geopy.distance import geodesic
import math

request_example = {
    "start": { "lat": float(56.462017), "lng": float(-2.970721)},  # Dundee
    "end": { "lat": float(55.953251), "lng": float(-3.188267)}  # Edinburgh
}

group_example = {
   "id": "q2no43tn3o4itq3o4itq34oitj",
   "name": "a_group",
   "path": "an encoded path following this specification: https://pypi.org/project/polyline/",
   "start": { "lat": float(57.147480), "lng":  float(-2.095400)},   # Aberdeen
   "end": { "lat": float(55.953251), "lng": float(-3.188267)}       # Edinburgh
}


def heron_formula(p, q, h):
    base = geodesic(p, q).miles                 # base of the triangle
    a = geodesic(p, h).miles
    b = geodesic(q, h).miles                    # other sides of triangle
    s = (base + a + b)/2                        # semiperimeter
    area = math.sqrt(s*(s-base)*(s-a)*(s-b))    # heron's formula
    height = (2*area)/base
    return height


# function to determine specific part of the group path: from where the height falls, to the end of the group path
def interesting_bit(height, h, a):
    hypotenuse = geodesic(h, a).miles
    interesting = math.sqrt(hypotenuse**2 - height**2)
    return interesting
# issue: it does not consider direction, if direction is inverted, result is the same


def match(request, group):

   rstart = (request["start"]["lat"],request["start"]["lng"])
   rend = (request["end"]["lat"],request["end"]["lng"])
   gstart = (group["start"]["lat"],group["start"]["lng"])
   gend = (group["end"]["lat"],group["end"]["lng"])

   start_path_dist = heron_formula(gstart, gend, rstart)  # distance as crow flies from user start loc to group path
   end_path_dist = heron_formula(gstart, gend, rend)    # distance as crow flies from user end loc to group path

   # part of the group path the user is interested in
   interesting_path = (interesting_bit(start_path_dist, rstart, gend) - interesting_bit(end_path_dist, rend, gend))
   if interesting_path > 0: 
       # total length of the user's journey
       tot = interesting_path + start_path_dist + end_path_dist
       match = (interesting_path/tot) * 100
   else : 
        match = 0

   return match

value = match(request_example, group_example)
print(value)  
