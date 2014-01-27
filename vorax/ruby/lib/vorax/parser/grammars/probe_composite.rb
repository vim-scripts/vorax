
# line 1 "lib/vorax/parser/grammars/probe_composite.rl"

# line 45 "lib/vorax/parser/grammars/probe_composite.rl"


module Vorax

  module Parser

    class CompositeRegion < NamedRegion

      # Tries to figure out the type of the composite region.
      # @param data [String] the PLSQL code to be checked
      # @return [Hash] with the following keys: :name => the name of the plsql object,
      #   :kind => the valid values are: :package_spec, :package_body or :type_body
      #   :pointer => where the package spec definition ends as a relative position to
      #   the string provided as parameter. This is the position right after the AS|IS
      #   mark. If the spec could not be matched the pointer is nil.
      # @example
      #   text = 'create or replace package scott.text as g_var integer; end;'
      #   p Parser::CompositeRegion.probe(text)
      def self.probe(data)
				@pos_name_temp, @pos_name, @kind, @kind_temp, @pointer, @name_temp, @name = nil
				if data
					eof = data.length
					
# line 29 "lib/vorax/parser/grammars/probe_composite.rb"
class << self
	attr_accessor :_spec_probe_actions
	private :_spec_probe_actions, :_spec_probe_actions=
end
self._spec_probe_actions = [
	0, 1, 0, 1, 1, 1, 2, 1, 
	3, 1, 4, 1, 5, 1, 6, 2, 
	1, 5
]

class << self
	attr_accessor :_spec_probe_key_offsets
	private :_spec_probe_key_offsets, :_spec_probe_key_offsets=
end
self._spec_probe_key_offsets = [
	0, 0, 6, 8, 10, 12, 14, 16, 
	21, 32, 33, 34, 35, 36, 38, 40, 
	45, 52, 53, 54, 55, 56, 58, 60, 
	62, 64, 66, 68, 70, 75, 84, 85, 
	86, 87, 88, 90, 92, 94, 96, 98, 
	100, 102, 107, 138, 139, 145, 154, 155, 
	156, 157, 158, 160, 164, 169, 170, 171, 
	172, 173, 175, 177, 179, 181, 183, 188, 
	197, 198, 199, 200, 201, 203, 205, 207, 
	209, 211, 213, 215, 216, 218, 220, 222, 
	224, 229, 238, 239, 240, 241, 242, 244, 
	246, 248, 250, 252, 254, 262, 263, 269, 
	277, 278, 283, 297, 312, 327, 328, 329, 
	330, 331, 333, 352, 362, 379, 396, 413, 
	430, 447, 464, 481, 496, 527, 528, 534, 
	542, 543, 549, 557, 558, 563, 577, 592, 
	607, 608, 609, 610, 611, 613, 632, 642, 
	659, 676, 693, 710, 727, 744, 761, 780, 
	797, 814, 831, 848, 865, 882, 899, 916, 
	933, 948, 965, 982, 999, 1016, 1033, 1050, 
	1067, 1084, 1101, 1118, 1135, 1152, 1169, 1186, 
	1203, 1220, 1237, 1254, 1271, 1288, 1305, 1324, 
	1341, 1358, 1375, 1392, 1409, 1426, 1443, 1460, 
	1477, 1492, 1509, 1526, 1543, 1560, 1577, 1594, 
	1611, 1628, 1645, 1662, 1679, 1696, 1713, 1730, 
	1747, 1764, 1781, 1798, 1815, 1832, 1849, 1851, 
	1853, 1855, 1860, 1891, 1892, 1898, 1899, 1900, 
	1901, 1902, 1904, 1912, 1913, 1919, 1927, 1928, 
	1933, 1947, 1962, 1977, 1978, 1979, 1980, 1981, 
	1983, 2002, 2012, 2029, 2046, 2063, 2080, 2097, 
	2114, 2131, 2146, 2165, 2182, 2199, 2216, 2233, 
	2250, 2267, 2284, 2301, 2318, 2333, 2350, 2367, 
	2384, 2401, 2418, 2435, 2452, 2469, 2486, 2503, 
	2520, 2537, 2554, 2571, 2588, 2605, 2622, 2639, 
	2656, 2673, 2690, 2695
]

class << self
	attr_accessor :_spec_probe_trans_keys
	private :_spec_probe_trans_keys, :_spec_probe_trans_keys=
end
self._spec_probe_trans_keys = [
	67, 80, 84, 99, 112, 116, 82, 114, 
	69, 101, 65, 97, 84, 116, 69, 101, 
	32, 45, 47, 9, 13, 32, 45, 47, 
	79, 80, 84, 111, 112, 116, 9, 13, 
	45, 10, 42, 42, 42, 47, 82, 114, 
	32, 45, 47, 9, 13, 32, 45, 47, 
	82, 114, 9, 13, 45, 10, 42, 42, 
	42, 47, 69, 101, 80, 112, 76, 108, 
	65, 97, 67, 99, 69, 101, 32, 45, 
	47, 9, 13, 32, 45, 47, 80, 84, 
	112, 116, 9, 13, 45, 10, 42, 42, 
	42, 47, 65, 97, 67, 99, 75, 107, 
	65, 97, 71, 103, 69, 101, 32, 45, 
	47, 9, 13, 32, 34, 45, 47, 65, 
	66, 67, 68, 73, 79, 80, 82, 84, 
	95, 97, 98, 99, 100, 105, 111, 112, 
	114, 116, 9, 13, 35, 36, 69, 90, 
	101, 122, 34, 32, 45, 46, 47, 9, 
	13, 32, 45, 47, 65, 73, 97, 105, 
	9, 13, 45, 10, 42, 42, 42, 47, 
	83, 85, 115, 117, 32, 45, 47, 9, 
	13, 45, 10, 42, 42, 42, 47, 84, 
	116, 72, 104, 73, 105, 68, 100, 32, 
	45, 47, 9, 13, 32, 45, 47, 67, 
	68, 99, 100, 9, 13, 45, 10, 42, 
	42, 42, 47, 85, 117, 82, 114, 82, 
	114, 69, 101, 78, 110, 84, 116, 95, 
	85, 117, 83, 115, 69, 101, 82, 114, 
	32, 45, 47, 9, 13, 32, 45, 47, 
	65, 73, 97, 105, 9, 13, 45, 10, 
	42, 42, 42, 47, 83, 115, 69, 101, 
	70, 102, 73, 105, 78, 110, 34, 95, 
	35, 36, 65, 90, 97, 122, 34, 32, 
	45, 46, 47, 9, 13, 34, 95, 35, 
	36, 65, 90, 97, 122, 34, 32, 45, 
	47, 9, 13, 32, 45, 47, 95, 9, 
	13, 35, 36, 48, 57, 65, 90, 97, 
	122, 32, 45, 46, 47, 95, 9, 13, 
	35, 36, 48, 57, 65, 90, 97, 122, 
	32, 45, 46, 47, 95, 9, 13, 35, 
	36, 48, 57, 65, 90, 97, 122, 45, 
	10, 42, 42, 42, 47, 32, 45, 46, 
	47, 83, 85, 95, 115, 117, 9, 13, 
	35, 36, 48, 57, 65, 90, 97, 122, 
	46, 95, 35, 36, 48, 57, 65, 90, 
	97, 122, 32, 45, 46, 47, 84, 95, 
	116, 9, 13, 35, 36, 48, 57, 65, 
	90, 97, 122, 32, 45, 46, 47, 72, 
	95, 104, 9, 13, 35, 36, 48, 57, 
	65, 90, 97, 122, 32, 45, 46, 47, 
	73, 95, 105, 9, 13, 35, 36, 48, 
	57, 65, 90, 97, 122, 32, 45, 46, 
	47, 68, 95, 100, 9, 13, 35, 36, 
	48, 57, 65, 90, 97, 122, 32, 45, 
	46, 47, 79, 95, 111, 9, 13, 35, 
	36, 48, 57, 65, 90, 97, 122, 32, 
	45, 46, 47, 68, 95, 100, 9, 13, 
	35, 36, 48, 57, 65, 90, 97, 122, 
	32, 45, 46, 47, 89, 95, 121, 9, 
	13, 35, 36, 48, 57, 65, 90, 97, 
	122, 32, 45, 46, 47, 95, 9, 13, 
	35, 36, 48, 57, 65, 90, 97, 122, 
	32, 34, 45, 47, 65, 66, 67, 68, 
	73, 79, 80, 82, 84, 95, 97, 98, 
	99, 100, 105, 111, 112, 114, 116, 9, 
	13, 35, 36, 69, 90, 101, 122, 34, 
	32, 45, 46, 47, 9, 13, 34, 95, 
	35, 36, 65, 90, 97, 122, 34, 32, 
	45, 46, 47, 9, 13, 34, 95, 35, 
	36, 65, 90, 97, 122, 34, 32, 45, 
	47, 9, 13, 32, 45, 47, 95, 9, 
	13, 35, 36, 48, 57, 65, 90, 97, 
	122, 32, 45, 46, 47, 95, 9, 13, 
	35, 36, 48, 57, 65, 90, 97, 122, 
	32, 45, 46, 47, 95, 9, 13, 35, 
	36, 48, 57, 65, 90, 97, 122, 45, 
	10, 42, 42, 42, 47, 32, 45, 46, 
	47, 83, 85, 95, 115, 117, 9, 13, 
	35, 36, 48, 57, 65, 90, 97, 122, 
	46, 95, 35, 36, 48, 57, 65, 90, 
	97, 122, 32, 45, 46, 47, 84, 95, 
	116, 9, 13, 35, 36, 48, 57, 65, 
	90, 97, 122, 32, 45, 46, 47, 72, 
	95, 104, 9, 13, 35, 36, 48, 57, 
	65, 90, 97, 122, 32, 45, 46, 47, 
	73, 95, 105, 9, 13, 35, 36, 48, 
	57, 65, 90, 97, 122, 32, 45, 46, 
	47, 68, 95, 100, 9, 13, 35, 36, 
	48, 57, 65, 90, 97, 122, 32, 45, 
	46, 47, 79, 95, 111, 9, 13, 35, 
	36, 48, 57, 65, 90, 97, 122, 32, 
	45, 46, 47, 68, 95, 100, 9, 13, 
	35, 36, 48, 57, 65, 90, 97, 122, 
	32, 45, 46, 47, 89, 95, 121, 9, 
	13, 35, 36, 48, 57, 65, 90, 97, 
	122, 32, 45, 46, 47, 82, 85, 95, 
	114, 117, 9, 13, 35, 36, 48, 57, 
	65, 90, 97, 122, 32, 45, 46, 47, 
	69, 95, 101, 9, 13, 35, 36, 48, 
	57, 65, 90, 97, 122, 32, 45, 46, 
	47, 65, 95, 97, 9, 13, 35, 36, 
	48, 57, 66, 90, 98, 122, 32, 45, 
	46, 47, 84, 95, 116, 9, 13, 35, 
	36, 48, 57, 65, 90, 97, 122, 32, 
	45, 46, 47, 69, 95, 101, 9, 13, 
	35, 36, 48, 57, 65, 90, 97, 122, 
	32, 45, 46, 47, 82, 95, 114, 9, 
	13, 35, 36, 48, 57, 65, 90, 97, 
	122, 32, 45, 46, 47, 82, 95, 114, 
	9, 13, 35, 36, 48, 57, 65, 90, 
	97, 122, 32, 45, 46, 47, 69, 95, 
	101, 9, 13, 35, 36, 48, 57, 65, 
	90, 97, 122, 32, 45, 46, 47, 78, 
	95, 110, 9, 13, 35, 36, 48, 57, 
	65, 90, 97, 122, 32, 45, 46, 47, 
	84, 95, 116, 9, 13, 35, 36, 48, 
	57, 65, 90, 97, 122, 32, 45, 46, 
	47, 95, 9, 13, 35, 36, 48, 57, 
	65, 90, 97, 122, 32, 45, 46, 47, 
	85, 95, 117, 9, 13, 35, 36, 48, 
	57, 65, 90, 97, 122, 32, 45, 46, 
	47, 83, 95, 115, 9, 13, 35, 36, 
	48, 57, 65, 90, 97, 122, 32, 45, 
	46, 47, 69, 95, 101, 9, 13, 35, 
	36, 48, 57, 65, 90, 97, 122, 32, 
	45, 46, 47, 82, 95, 114, 9, 13, 
	35, 36, 48, 57, 65, 90, 97, 122, 
	32, 45, 46, 47, 69, 95, 101, 9, 
	13, 35, 36, 48, 57, 65, 90, 97, 
	122, 32, 45, 46, 47, 70, 95, 102, 
	9, 13, 35, 36, 48, 57, 65, 90, 
	97, 122, 32, 45, 46, 47, 73, 95, 
	105, 9, 13, 35, 36, 48, 57, 65, 
	90, 97, 122, 32, 45, 46, 47, 78, 
	95, 110, 9, 13, 35, 36, 48, 57, 
	65, 90, 97, 122, 32, 45, 46, 47, 
	83, 95, 115, 9, 13, 35, 36, 48, 
	57, 65, 90, 97, 122, 32, 45, 46, 
	47, 65, 95, 97, 9, 13, 35, 36, 
	48, 57, 66, 90, 98, 122, 32, 45, 
	46, 47, 67, 95, 99, 9, 13, 35, 
	36, 48, 57, 65, 90, 97, 122, 32, 
	45, 46, 47, 75, 95, 107, 9, 13, 
	35, 36, 48, 57, 65, 90, 97, 122, 
	32, 45, 46, 47, 65, 95, 97, 9, 
	13, 35, 36, 48, 57, 66, 90, 98, 
	122, 32, 45, 46, 47, 71, 95, 103, 
	9, 13, 35, 36, 48, 57, 65, 90, 
	97, 122, 32, 45, 46, 47, 69, 95, 
	101, 9, 13, 35, 36, 48, 57, 65, 
	90, 97, 122, 32, 45, 46, 47, 80, 
	95, 112, 9, 13, 35, 36, 48, 57, 
	65, 90, 97, 122, 32, 45, 46, 47, 
	76, 95, 108, 9, 13, 35, 36, 48, 
	57, 65, 90, 97, 122, 32, 45, 46, 
	47, 65, 95, 97, 9, 13, 35, 36, 
	48, 57, 66, 90, 98, 122, 32, 45, 
	46, 47, 67, 95, 99, 9, 13, 35, 
	36, 48, 57, 65, 90, 97, 122, 32, 
	45, 46, 47, 89, 95, 121, 9, 13, 
	35, 36, 48, 57, 65, 90, 97, 122, 
	32, 45, 46, 47, 80, 95, 112, 9, 
	13, 35, 36, 48, 57, 65, 90, 97, 
	122, 32, 45, 46, 47, 82, 85, 95, 
	114, 117, 9, 13, 35, 36, 48, 57, 
	65, 90, 97, 122, 32, 45, 46, 47, 
	69, 95, 101, 9, 13, 35, 36, 48, 
	57, 65, 90, 97, 122, 32, 45, 46, 
	47, 65, 95, 97, 9, 13, 35, 36, 
	48, 57, 66, 90, 98, 122, 32, 45, 
	46, 47, 84, 95, 116, 9, 13, 35, 
	36, 48, 57, 65, 90, 97, 122, 32, 
	45, 46, 47, 69, 95, 101, 9, 13, 
	35, 36, 48, 57, 65, 90, 97, 122, 
	32, 45, 46, 47, 82, 95, 114, 9, 
	13, 35, 36, 48, 57, 65, 90, 97, 
	122, 32, 45, 46, 47, 82, 95, 114, 
	9, 13, 35, 36, 48, 57, 65, 90, 
	97, 122, 32, 45, 46, 47, 69, 95, 
	101, 9, 13, 35, 36, 48, 57, 65, 
	90, 97, 122, 32, 45, 46, 47, 78, 
	95, 110, 9, 13, 35, 36, 48, 57, 
	65, 90, 97, 122, 32, 45, 46, 47, 
	84, 95, 116, 9, 13, 35, 36, 48, 
	57, 65, 90, 97, 122, 32, 45, 46, 
	47, 95, 9, 13, 35, 36, 48, 57, 
	65, 90, 97, 122, 32, 45, 46, 47, 
	85, 95, 117, 9, 13, 35, 36, 48, 
	57, 65, 90, 97, 122, 32, 45, 46, 
	47, 83, 95, 115, 9, 13, 35, 36, 
	48, 57, 65, 90, 97, 122, 32, 45, 
	46, 47, 69, 95, 101, 9, 13, 35, 
	36, 48, 57, 65, 90, 97, 122, 32, 
	45, 46, 47, 82, 95, 114, 9, 13, 
	35, 36, 48, 57, 65, 90, 97, 122, 
	32, 45, 46, 47, 69, 95, 101, 9, 
	13, 35, 36, 48, 57, 65, 90, 97, 
	122, 32, 45, 46, 47, 70, 95, 102, 
	9, 13, 35, 36, 48, 57, 65, 90, 
	97, 122, 32, 45, 46, 47, 73, 95, 
	105, 9, 13, 35, 36, 48, 57, 65, 
	90, 97, 122, 32, 45, 46, 47, 78, 
	95, 110, 9, 13, 35, 36, 48, 57, 
	65, 90, 97, 122, 32, 45, 46, 47, 
	83, 95, 115, 9, 13, 35, 36, 48, 
	57, 65, 90, 97, 122, 32, 45, 46, 
	47, 65, 95, 97, 9, 13, 35, 36, 
	48, 57, 66, 90, 98, 122, 32, 45, 
	46, 47, 67, 95, 99, 9, 13, 35, 
	36, 48, 57, 65, 90, 97, 122, 32, 
	45, 46, 47, 75, 95, 107, 9, 13, 
	35, 36, 48, 57, 65, 90, 97, 122, 
	32, 45, 46, 47, 65, 95, 97, 9, 
	13, 35, 36, 48, 57, 66, 90, 98, 
	122, 32, 45, 46, 47, 71, 95, 103, 
	9, 13, 35, 36, 48, 57, 65, 90, 
	97, 122, 32, 45, 46, 47, 69, 95, 
	101, 9, 13, 35, 36, 48, 57, 65, 
	90, 97, 122, 32, 45, 46, 47, 80, 
	95, 112, 9, 13, 35, 36, 48, 57, 
	65, 90, 97, 122, 32, 45, 46, 47, 
	76, 95, 108, 9, 13, 35, 36, 48, 
	57, 65, 90, 97, 122, 32, 45, 46, 
	47, 65, 95, 97, 9, 13, 35, 36, 
	48, 57, 66, 90, 98, 122, 32, 45, 
	46, 47, 67, 95, 99, 9, 13, 35, 
	36, 48, 57, 65, 90, 97, 122, 32, 
	45, 46, 47, 89, 95, 121, 9, 13, 
	35, 36, 48, 57, 65, 90, 97, 122, 
	32, 45, 46, 47, 80, 95, 112, 9, 
	13, 35, 36, 48, 57, 65, 90, 97, 
	122, 89, 121, 80, 112, 69, 101, 32, 
	45, 47, 9, 13, 32, 34, 45, 47, 
	65, 66, 67, 68, 73, 79, 80, 82, 
	84, 95, 97, 98, 99, 100, 105, 111, 
	112, 114, 116, 9, 13, 35, 36, 69, 
	90, 101, 122, 34, 32, 45, 46, 47, 
	9, 13, 45, 10, 42, 42, 42, 47, 
	34, 95, 35, 36, 65, 90, 97, 122, 
	34, 32, 45, 46, 47, 9, 13, 34, 
	95, 35, 36, 65, 90, 97, 122, 34, 
	32, 45, 47, 9, 13, 32, 45, 47, 
	95, 9, 13, 35, 36, 48, 57, 65, 
	90, 97, 122, 32, 45, 46, 47, 95, 
	9, 13, 35, 36, 48, 57, 65, 90, 
	97, 122, 32, 45, 46, 47, 95, 9, 
	13, 35, 36, 48, 57, 65, 90, 97, 
	122, 45, 10, 42, 42, 42, 47, 32, 
	45, 46, 47, 83, 85, 95, 115, 117, 
	9, 13, 35, 36, 48, 57, 65, 90, 
	97, 122, 46, 95, 35, 36, 48, 57, 
	65, 90, 97, 122, 32, 45, 46, 47, 
	84, 95, 116, 9, 13, 35, 36, 48, 
	57, 65, 90, 97, 122, 32, 45, 46, 
	47, 72, 95, 104, 9, 13, 35, 36, 
	48, 57, 65, 90, 97, 122, 32, 45, 
	46, 47, 73, 95, 105, 9, 13, 35, 
	36, 48, 57, 65, 90, 97, 122, 32, 
	45, 46, 47, 68, 95, 100, 9, 13, 
	35, 36, 48, 57, 65, 90, 97, 122, 
	32, 45, 46, 47, 79, 95, 111, 9, 
	13, 35, 36, 48, 57, 65, 90, 97, 
	122, 32, 45, 46, 47, 68, 95, 100, 
	9, 13, 35, 36, 48, 57, 65, 90, 
	97, 122, 32, 45, 46, 47, 89, 95, 
	121, 9, 13, 35, 36, 48, 57, 65, 
	90, 97, 122, 32, 45, 46, 47, 95, 
	9, 13, 35, 36, 48, 57, 65, 90, 
	97, 122, 32, 45, 46, 47, 82, 85, 
	95, 114, 117, 9, 13, 35, 36, 48, 
	57, 65, 90, 97, 122, 32, 45, 46, 
	47, 69, 95, 101, 9, 13, 35, 36, 
	48, 57, 65, 90, 97, 122, 32, 45, 
	46, 47, 65, 95, 97, 9, 13, 35, 
	36, 48, 57, 66, 90, 98, 122, 32, 
	45, 46, 47, 84, 95, 116, 9, 13, 
	35, 36, 48, 57, 65, 90, 97, 122, 
	32, 45, 46, 47, 69, 95, 101, 9, 
	13, 35, 36, 48, 57, 65, 90, 97, 
	122, 32, 45, 46, 47, 82, 95, 114, 
	9, 13, 35, 36, 48, 57, 65, 90, 
	97, 122, 32, 45, 46, 47, 82, 95, 
	114, 9, 13, 35, 36, 48, 57, 65, 
	90, 97, 122, 32, 45, 46, 47, 69, 
	95, 101, 9, 13, 35, 36, 48, 57, 
	65, 90, 97, 122, 32, 45, 46, 47, 
	78, 95, 110, 9, 13, 35, 36, 48, 
	57, 65, 90, 97, 122, 32, 45, 46, 
	47, 84, 95, 116, 9, 13, 35, 36, 
	48, 57, 65, 90, 97, 122, 32, 45, 
	46, 47, 95, 9, 13, 35, 36, 48, 
	57, 65, 90, 97, 122, 32, 45, 46, 
	47, 85, 95, 117, 9, 13, 35, 36, 
	48, 57, 65, 90, 97, 122, 32, 45, 
	46, 47, 83, 95, 115, 9, 13, 35, 
	36, 48, 57, 65, 90, 97, 122, 32, 
	45, 46, 47, 69, 95, 101, 9, 13, 
	35, 36, 48, 57, 65, 90, 97, 122, 
	32, 45, 46, 47, 82, 95, 114, 9, 
	13, 35, 36, 48, 57, 65, 90, 97, 
	122, 32, 45, 46, 47, 69, 95, 101, 
	9, 13, 35, 36, 48, 57, 65, 90, 
	97, 122, 32, 45, 46, 47, 70, 95, 
	102, 9, 13, 35, 36, 48, 57, 65, 
	90, 97, 122, 32, 45, 46, 47, 73, 
	95, 105, 9, 13, 35, 36, 48, 57, 
	65, 90, 97, 122, 32, 45, 46, 47, 
	78, 95, 110, 9, 13, 35, 36, 48, 
	57, 65, 90, 97, 122, 32, 45, 46, 
	47, 83, 95, 115, 9, 13, 35, 36, 
	48, 57, 65, 90, 97, 122, 32, 45, 
	46, 47, 65, 95, 97, 9, 13, 35, 
	36, 48, 57, 66, 90, 98, 122, 32, 
	45, 46, 47, 67, 95, 99, 9, 13, 
	35, 36, 48, 57, 65, 90, 97, 122, 
	32, 45, 46, 47, 75, 95, 107, 9, 
	13, 35, 36, 48, 57, 65, 90, 97, 
	122, 32, 45, 46, 47, 65, 95, 97, 
	9, 13, 35, 36, 48, 57, 66, 90, 
	98, 122, 32, 45, 46, 47, 71, 95, 
	103, 9, 13, 35, 36, 48, 57, 65, 
	90, 97, 122, 32, 45, 46, 47, 69, 
	95, 101, 9, 13, 35, 36, 48, 57, 
	65, 90, 97, 122, 32, 45, 46, 47, 
	80, 95, 112, 9, 13, 35, 36, 48, 
	57, 65, 90, 97, 122, 32, 45, 46, 
	47, 76, 95, 108, 9, 13, 35, 36, 
	48, 57, 65, 90, 97, 122, 32, 45, 
	46, 47, 65, 95, 97, 9, 13, 35, 
	36, 48, 57, 66, 90, 98, 122, 32, 
	45, 46, 47, 67, 95, 99, 9, 13, 
	35, 36, 48, 57, 65, 90, 97, 122, 
	32, 45, 46, 47, 89, 95, 121, 9, 
	13, 35, 36, 48, 57, 65, 90, 97, 
	122, 32, 45, 46, 47, 80, 95, 112, 
	9, 13, 35, 36, 48, 57, 65, 90, 
	97, 122, 32, 45, 47, 9, 13, 32, 
	45, 47, 9, 13, 0
]

class << self
	attr_accessor :_spec_probe_single_lengths
	private :_spec_probe_single_lengths, :_spec_probe_single_lengths=
end
self._spec_probe_single_lengths = [
	0, 6, 2, 2, 2, 2, 2, 3, 
	9, 1, 1, 1, 1, 2, 2, 3, 
	5, 1, 1, 1, 1, 2, 2, 2, 
	2, 2, 2, 2, 3, 7, 1, 1, 
	1, 1, 2, 2, 2, 2, 2, 2, 
	2, 3, 23, 1, 4, 7, 1, 1, 
	1, 1, 2, 4, 3, 1, 1, 1, 
	1, 2, 2, 2, 2, 2, 3, 7, 
	1, 1, 1, 1, 2, 2, 2, 2, 
	2, 2, 2, 1, 2, 2, 2, 2, 
	3, 7, 1, 1, 1, 1, 2, 2, 
	2, 2, 2, 2, 2, 1, 4, 2, 
	1, 3, 4, 5, 5, 1, 1, 1, 
	1, 2, 9, 2, 7, 7, 7, 7, 
	7, 7, 7, 5, 23, 1, 4, 2, 
	1, 4, 2, 1, 3, 4, 5, 5, 
	1, 1, 1, 1, 2, 9, 2, 7, 
	7, 7, 7, 7, 7, 7, 9, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	5, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 9, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	5, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 2, 2, 
	2, 3, 23, 1, 4, 1, 1, 1, 
	1, 2, 2, 1, 4, 2, 1, 3, 
	4, 5, 5, 1, 1, 1, 1, 2, 
	9, 2, 7, 7, 7, 7, 7, 7, 
	7, 5, 9, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 5, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 3, 3
]

class << self
	attr_accessor :_spec_probe_range_lengths
	private :_spec_probe_range_lengths, :_spec_probe_range_lengths=
end
self._spec_probe_range_lengths = [
	0, 0, 0, 0, 0, 0, 0, 1, 
	1, 0, 0, 0, 0, 0, 0, 1, 
	1, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 1, 1, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 1, 4, 0, 1, 1, 0, 0, 
	0, 0, 0, 0, 1, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 1, 1, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	1, 1, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 3, 0, 1, 3, 
	0, 1, 5, 5, 5, 0, 0, 0, 
	0, 0, 5, 4, 5, 5, 5, 5, 
	5, 5, 5, 5, 4, 0, 1, 3, 
	0, 1, 3, 0, 1, 5, 5, 5, 
	0, 0, 0, 0, 0, 5, 4, 5, 
	5, 5, 5, 5, 5, 5, 5, 5, 
	5, 5, 5, 5, 5, 5, 5, 5, 
	5, 5, 5, 5, 5, 5, 5, 5, 
	5, 5, 5, 5, 5, 5, 5, 5, 
	5, 5, 5, 5, 5, 5, 5, 5, 
	5, 5, 5, 5, 5, 5, 5, 5, 
	5, 5, 5, 5, 5, 5, 5, 5, 
	5, 5, 5, 5, 5, 5, 5, 5, 
	5, 5, 5, 5, 5, 5, 0, 0, 
	0, 1, 4, 0, 1, 0, 0, 0, 
	0, 0, 3, 0, 1, 3, 0, 1, 
	5, 5, 5, 0, 0, 0, 0, 0, 
	5, 4, 5, 5, 5, 5, 5, 5, 
	5, 5, 5, 5, 5, 5, 5, 5, 
	5, 5, 5, 5, 5, 5, 5, 5, 
	5, 5, 5, 5, 5, 5, 5, 5, 
	5, 5, 5, 5, 5, 5, 5, 5, 
	5, 5, 1, 1
]

class << self
	attr_accessor :_spec_probe_index_offsets
	private :_spec_probe_index_offsets, :_spec_probe_index_offsets=
end
self._spec_probe_index_offsets = [
	0, 0, 7, 10, 13, 16, 19, 22, 
	27, 38, 40, 42, 44, 46, 49, 52, 
	57, 64, 66, 68, 70, 72, 75, 78, 
	81, 84, 87, 90, 93, 98, 107, 109, 
	111, 113, 115, 118, 121, 124, 127, 130, 
	133, 136, 141, 169, 171, 177, 186, 188, 
	190, 192, 194, 197, 202, 207, 209, 211, 
	213, 215, 218, 221, 224, 227, 230, 235, 
	244, 246, 248, 250, 252, 255, 258, 261, 
	264, 267, 270, 273, 275, 278, 281, 284, 
	287, 292, 301, 303, 305, 307, 309, 312, 
	315, 318, 321, 324, 327, 333, 335, 341, 
	347, 349, 354, 364, 375, 386, 388, 390, 
	392, 394, 397, 412, 419, 432, 445, 458, 
	471, 484, 497, 510, 521, 549, 551, 557, 
	563, 565, 571, 577, 579, 584, 594, 605, 
	616, 618, 620, 622, 624, 627, 642, 649, 
	662, 675, 688, 701, 714, 727, 740, 755, 
	768, 781, 794, 807, 820, 833, 846, 859, 
	872, 883, 896, 909, 922, 935, 948, 961, 
	974, 987, 1000, 1013, 1026, 1039, 1052, 1065, 
	1078, 1091, 1104, 1117, 1130, 1143, 1156, 1171, 
	1184, 1197, 1210, 1223, 1236, 1249, 1262, 1275, 
	1288, 1299, 1312, 1325, 1338, 1351, 1364, 1377, 
	1390, 1403, 1416, 1429, 1442, 1455, 1468, 1481, 
	1494, 1507, 1520, 1533, 1546, 1559, 1572, 1575, 
	1578, 1581, 1586, 1614, 1616, 1622, 1624, 1626, 
	1628, 1630, 1633, 1639, 1641, 1647, 1653, 1655, 
	1660, 1670, 1681, 1692, 1694, 1696, 1698, 1700, 
	1703, 1718, 1725, 1738, 1751, 1764, 1777, 1790, 
	1803, 1816, 1827, 1842, 1855, 1868, 1881, 1894, 
	1907, 1920, 1933, 1946, 1959, 1970, 1983, 1996, 
	2009, 2022, 2035, 2048, 2061, 2074, 2087, 2100, 
	2113, 2126, 2139, 2152, 2165, 2178, 2191, 2204, 
	2217, 2230, 2243, 2248
]

class << self
	attr_accessor :_spec_probe_indicies
	private :_spec_probe_indicies, :_spec_probe_indicies=
end
self._spec_probe_indicies = [
	0, 2, 3, 0, 2, 3, 1, 4, 
	4, 1, 5, 5, 1, 6, 6, 1, 
	7, 7, 1, 8, 8, 1, 9, 10, 
	11, 9, 1, 9, 10, 11, 12, 2, 
	3, 12, 2, 3, 9, 1, 13, 1, 
	9, 13, 14, 1, 15, 14, 15, 9, 
	14, 16, 16, 1, 17, 18, 19, 17, 
	1, 17, 18, 19, 20, 20, 17, 1, 
	21, 1, 17, 21, 22, 1, 23, 22, 
	23, 17, 22, 24, 24, 1, 25, 25, 
	1, 26, 26, 1, 27, 27, 1, 28, 
	28, 1, 29, 29, 1, 30, 31, 32, 
	30, 1, 30, 31, 32, 2, 3, 2, 
	3, 30, 1, 33, 1, 30, 33, 34, 
	1, 35, 34, 35, 30, 34, 36, 36, 
	1, 37, 37, 1, 38, 38, 1, 39, 
	39, 1, 40, 40, 1, 41, 41, 1, 
	42, 43, 44, 42, 1, 45, 46, 48, 
	49, 50, 51, 52, 53, 54, 55, 56, 
	57, 58, 47, 50, 51, 52, 53, 54, 
	55, 56, 57, 58, 45, 47, 47, 47, 
	1, 60, 59, 61, 62, 63, 64, 61, 
	1, 65, 66, 67, 68, 69, 68, 69, 
	65, 1, 70, 1, 65, 70, 71, 1, 
	72, 71, 72, 65, 71, 73, 74, 73, 
	74, 1, 75, 76, 77, 75, 1, 78, 
	1, 79, 78, 80, 1, 81, 80, 81, 
	79, 80, 82, 82, 1, 83, 83, 1, 
	84, 84, 1, 85, 85, 1, 86, 87, 
	88, 86, 1, 86, 87, 88, 89, 90, 
	89, 90, 86, 1, 91, 1, 86, 91, 
	92, 1, 93, 92, 93, 86, 92, 94, 
	94, 1, 95, 95, 1, 96, 96, 1, 
	97, 97, 1, 98, 98, 1, 99, 99, 
	1, 100, 1, 101, 101, 1, 102, 102, 
	1, 103, 103, 1, 104, 104, 1, 105, 
	106, 107, 105, 1, 105, 106, 107, 69, 
	69, 69, 69, 105, 1, 108, 1, 105, 
	108, 109, 1, 110, 109, 110, 105, 109, 
	73, 73, 1, 111, 111, 1, 112, 112, 
	1, 113, 113, 1, 102, 102, 1, 114, 
	115, 115, 115, 115, 1, 116, 114, 61, 
	62, 117, 64, 61, 1, 118, 119, 119, 
	119, 119, 1, 120, 118, 61, 62, 64, 
	61, 1, 61, 62, 64, 119, 61, 119, 
	119, 119, 119, 1, 61, 62, 117, 64, 
	115, 61, 115, 115, 115, 115, 1, 61, 
	62, 63, 64, 121, 61, 121, 121, 121, 
	121, 1, 122, 1, 45, 122, 123, 1, 
	124, 123, 124, 45, 123, 61, 62, 63, 
	64, 125, 126, 121, 125, 126, 61, 121, 
	121, 121, 121, 1, 63, 121, 121, 121, 
	121, 121, 1, 61, 62, 63, 64, 127, 
	121, 127, 61, 121, 121, 121, 121, 1, 
	61, 62, 63, 64, 128, 121, 128, 61, 
	121, 121, 121, 121, 1, 61, 62, 63, 
	64, 129, 121, 129, 61, 121, 121, 121, 
	121, 1, 61, 62, 63, 64, 125, 121, 
	125, 61, 121, 121, 121, 121, 1, 61, 
	62, 63, 64, 130, 121, 130, 61, 121, 
	121, 121, 121, 1, 61, 62, 63, 64, 
	131, 121, 131, 61, 121, 121, 121, 121, 
	1, 61, 62, 63, 64, 132, 121, 132, 
	61, 121, 121, 121, 121, 1, 133, 134, 
	63, 135, 121, 133, 121, 121, 121, 121, 
	1, 136, 137, 139, 140, 141, 142, 143, 
	144, 145, 146, 147, 148, 149, 138, 141, 
	142, 143, 144, 145, 146, 147, 148, 149, 
	136, 138, 138, 138, 1, 151, 150, 152, 
	153, 154, 155, 152, 1, 156, 157, 157, 
	157, 157, 1, 158, 156, 152, 153, 159, 
	155, 152, 1, 160, 161, 161, 161, 161, 
	1, 162, 160, 152, 153, 155, 152, 1, 
	152, 153, 155, 161, 152, 161, 161, 161, 
	161, 1, 152, 153, 159, 155, 157, 152, 
	157, 157, 157, 157, 1, 152, 153, 154, 
	155, 163, 152, 163, 163, 163, 163, 1, 
	164, 1, 136, 164, 165, 1, 166, 165, 
	166, 136, 165, 152, 153, 154, 155, 167, 
	168, 163, 167, 168, 152, 163, 163, 163, 
	163, 1, 154, 163, 163, 163, 163, 163, 
	1, 152, 153, 154, 155, 169, 163, 169, 
	152, 163, 163, 163, 163, 1, 152, 153, 
	154, 155, 170, 163, 170, 152, 163, 163, 
	163, 163, 1, 152, 153, 154, 155, 171, 
	163, 171, 152, 163, 163, 163, 163, 1, 
	152, 153, 154, 155, 167, 163, 167, 152, 
	163, 163, 163, 163, 1, 152, 153, 154, 
	155, 172, 163, 172, 152, 163, 163, 163, 
	163, 1, 152, 153, 154, 155, 173, 163, 
	173, 152, 163, 163, 163, 163, 1, 152, 
	153, 154, 155, 167, 163, 167, 152, 163, 
	163, 163, 163, 1, 152, 153, 154, 155, 
	174, 175, 163, 174, 175, 152, 163, 163, 
	163, 163, 1, 152, 153, 154, 155, 176, 
	163, 176, 152, 163, 163, 163, 163, 1, 
	152, 153, 154, 155, 177, 163, 177, 152, 
	163, 163, 163, 163, 1, 152, 153, 154, 
	155, 178, 163, 178, 152, 163, 163, 163, 
	163, 1, 152, 153, 154, 155, 167, 163, 
	167, 152, 163, 163, 163, 163, 1, 152, 
	153, 154, 155, 179, 163, 179, 152, 163, 
	163, 163, 163, 1, 152, 153, 154, 155, 
	180, 163, 180, 152, 163, 163, 163, 163, 
	1, 152, 153, 154, 155, 181, 163, 181, 
	152, 163, 163, 163, 163, 1, 152, 153, 
	154, 155, 182, 163, 182, 152, 163, 163, 
	163, 163, 1, 152, 153, 154, 155, 183, 
	163, 183, 152, 163, 163, 163, 163, 1, 
	152, 153, 154, 155, 184, 152, 163, 163, 
	163, 163, 1, 152, 153, 154, 155, 185, 
	163, 185, 152, 163, 163, 163, 163, 1, 
	152, 153, 154, 155, 186, 163, 186, 152, 
	163, 163, 163, 163, 1, 152, 153, 154, 
	155, 187, 163, 187, 152, 163, 163, 163, 
	163, 1, 152, 153, 154, 155, 167, 163, 
	167, 152, 163, 163, 163, 163, 1, 152, 
	153, 154, 155, 188, 163, 188, 152, 163, 
	163, 163, 163, 1, 152, 153, 154, 155, 
	189, 163, 189, 152, 163, 163, 163, 163, 
	1, 152, 153, 154, 155, 190, 163, 190, 
	152, 163, 163, 163, 163, 1, 152, 153, 
	154, 155, 186, 163, 186, 152, 163, 163, 
	163, 163, 1, 152, 153, 154, 155, 167, 
	163, 167, 152, 163, 163, 163, 163, 1, 
	152, 153, 154, 155, 191, 163, 191, 152, 
	163, 163, 163, 163, 1, 152, 153, 154, 
	155, 192, 163, 192, 152, 163, 163, 163, 
	163, 1, 152, 153, 154, 155, 193, 163, 
	193, 152, 163, 163, 163, 163, 1, 152, 
	153, 154, 155, 194, 163, 194, 152, 163, 
	163, 163, 163, 1, 152, 153, 154, 155, 
	178, 163, 178, 152, 163, 163, 163, 163, 
	1, 152, 153, 154, 155, 195, 163, 195, 
	152, 163, 163, 163, 163, 1, 152, 153, 
	154, 155, 196, 163, 196, 152, 163, 163, 
	163, 163, 1, 152, 153, 154, 155, 197, 
	163, 197, 152, 163, 163, 163, 163, 1, 
	152, 153, 154, 155, 198, 163, 198, 152, 
	163, 163, 163, 163, 1, 152, 153, 154, 
	155, 178, 163, 178, 152, 163, 163, 163, 
	163, 1, 152, 153, 154, 155, 199, 163, 
	199, 152, 163, 163, 163, 163, 1, 152, 
	153, 154, 155, 178, 163, 178, 152, 163, 
	163, 163, 163, 1, 61, 62, 63, 64, 
	200, 201, 121, 200, 201, 61, 121, 121, 
	121, 121, 1, 61, 62, 63, 64, 202, 
	121, 202, 61, 121, 121, 121, 121, 1, 
	61, 62, 63, 64, 203, 121, 203, 61, 
	121, 121, 121, 121, 1, 61, 62, 63, 
	64, 204, 121, 204, 61, 121, 121, 121, 
	121, 1, 61, 62, 63, 64, 125, 121, 
	125, 61, 121, 121, 121, 121, 1, 61, 
	62, 63, 64, 205, 121, 205, 61, 121, 
	121, 121, 121, 1, 61, 62, 63, 64, 
	206, 121, 206, 61, 121, 121, 121, 121, 
	1, 61, 62, 63, 64, 207, 121, 207, 
	61, 121, 121, 121, 121, 1, 61, 62, 
	63, 64, 208, 121, 208, 61, 121, 121, 
	121, 121, 1, 61, 62, 63, 64, 209, 
	121, 209, 61, 121, 121, 121, 121, 1, 
	61, 62, 63, 64, 210, 61, 121, 121, 
	121, 121, 1, 61, 62, 63, 64, 211, 
	121, 211, 61, 121, 121, 121, 121, 1, 
	61, 62, 63, 64, 212, 121, 212, 61, 
	121, 121, 121, 121, 1, 61, 62, 63, 
	64, 213, 121, 213, 61, 121, 121, 121, 
	121, 1, 61, 62, 63, 64, 125, 121, 
	125, 61, 121, 121, 121, 121, 1, 61, 
	62, 63, 64, 214, 121, 214, 61, 121, 
	121, 121, 121, 1, 61, 62, 63, 64, 
	215, 121, 215, 61, 121, 121, 121, 121, 
	1, 61, 62, 63, 64, 216, 121, 216, 
	61, 121, 121, 121, 121, 1, 61, 62, 
	63, 64, 212, 121, 212, 61, 121, 121, 
	121, 121, 1, 61, 62, 63, 64, 125, 
	121, 125, 61, 121, 121, 121, 121, 1, 
	61, 62, 63, 64, 217, 121, 217, 61, 
	121, 121, 121, 121, 1, 61, 62, 63, 
	64, 218, 121, 218, 61, 121, 121, 121, 
	121, 1, 61, 62, 63, 64, 219, 121, 
	219, 61, 121, 121, 121, 121, 1, 61, 
	62, 63, 64, 220, 121, 220, 61, 121, 
	121, 121, 121, 1, 61, 62, 63, 64, 
	204, 121, 204, 61, 121, 121, 121, 121, 
	1, 61, 62, 63, 64, 221, 121, 221, 
	61, 121, 121, 121, 121, 1, 61, 62, 
	63, 64, 222, 121, 222, 61, 121, 121, 
	121, 121, 1, 61, 62, 63, 64, 223, 
	121, 223, 61, 121, 121, 121, 121, 1, 
	61, 62, 63, 64, 224, 121, 224, 61, 
	121, 121, 121, 121, 1, 61, 62, 63, 
	64, 204, 121, 204, 61, 121, 121, 121, 
	121, 1, 61, 62, 63, 64, 225, 121, 
	225, 61, 121, 121, 121, 121, 1, 61, 
	62, 63, 64, 204, 121, 204, 61, 121, 
	121, 121, 121, 1, 226, 226, 1, 227, 
	227, 1, 228, 228, 1, 229, 230, 231, 
	229, 1, 229, 232, 230, 231, 234, 235, 
	236, 237, 238, 239, 240, 241, 242, 233, 
	234, 235, 236, 237, 238, 239, 240, 241, 
	242, 229, 233, 233, 233, 1, 244, 243, 
	245, 246, 247, 248, 245, 1, 249, 1, 
	250, 249, 251, 1, 252, 251, 252, 250, 
	251, 253, 254, 254, 254, 254, 1, 255, 
	253, 245, 246, 256, 248, 245, 1, 257, 
	258, 258, 258, 258, 1, 259, 257, 245, 
	246, 248, 245, 1, 245, 246, 248, 258, 
	245, 258, 258, 258, 258, 1, 245, 246, 
	256, 248, 254, 245, 254, 254, 254, 254, 
	1, 245, 246, 247, 248, 260, 245, 260, 
	260, 260, 260, 1, 261, 1, 229, 261, 
	262, 1, 263, 262, 263, 229, 262, 245, 
	246, 247, 248, 264, 265, 260, 264, 265, 
	245, 260, 260, 260, 260, 1, 247, 260, 
	260, 260, 260, 260, 1, 245, 246, 247, 
	248, 266, 260, 266, 245, 260, 260, 260, 
	260, 1, 245, 246, 247, 248, 267, 260, 
	267, 245, 260, 260, 260, 260, 1, 245, 
	246, 247, 248, 268, 260, 268, 245, 260, 
	260, 260, 260, 1, 245, 246, 247, 248, 
	264, 260, 264, 245, 260, 260, 260, 260, 
	1, 245, 246, 247, 248, 269, 260, 269, 
	245, 260, 260, 260, 260, 1, 245, 246, 
	247, 248, 270, 260, 270, 245, 260, 260, 
	260, 260, 1, 245, 246, 247, 248, 271, 
	260, 271, 245, 260, 260, 260, 260, 1, 
	272, 273, 247, 274, 260, 272, 260, 260, 
	260, 260, 1, 245, 246, 247, 248, 275, 
	276, 260, 275, 276, 245, 260, 260, 260, 
	260, 1, 245, 246, 247, 248, 277, 260, 
	277, 245, 260, 260, 260, 260, 1, 245, 
	246, 247, 248, 278, 260, 278, 245, 260, 
	260, 260, 260, 1, 245, 246, 247, 248, 
	279, 260, 279, 245, 260, 260, 260, 260, 
	1, 245, 246, 247, 248, 264, 260, 264, 
	245, 260, 260, 260, 260, 1, 245, 246, 
	247, 248, 280, 260, 280, 245, 260, 260, 
	260, 260, 1, 245, 246, 247, 248, 281, 
	260, 281, 245, 260, 260, 260, 260, 1, 
	245, 246, 247, 248, 282, 260, 282, 245, 
	260, 260, 260, 260, 1, 245, 246, 247, 
	248, 283, 260, 283, 245, 260, 260, 260, 
	260, 1, 245, 246, 247, 248, 284, 260, 
	284, 245, 260, 260, 260, 260, 1, 245, 
	246, 247, 248, 285, 245, 260, 260, 260, 
	260, 1, 245, 246, 247, 248, 286, 260, 
	286, 245, 260, 260, 260, 260, 1, 245, 
	246, 247, 248, 287, 260, 287, 245, 260, 
	260, 260, 260, 1, 245, 246, 247, 248, 
	288, 260, 288, 245, 260, 260, 260, 260, 
	1, 245, 246, 247, 248, 264, 260, 264, 
	245, 260, 260, 260, 260, 1, 245, 246, 
	247, 248, 289, 260, 289, 245, 260, 260, 
	260, 260, 1, 245, 246, 247, 248, 290, 
	260, 290, 245, 260, 260, 260, 260, 1, 
	245, 246, 247, 248, 291, 260, 291, 245, 
	260, 260, 260, 260, 1, 245, 246, 247, 
	248, 287, 260, 287, 245, 260, 260, 260, 
	260, 1, 245, 246, 247, 248, 264, 260, 
	264, 245, 260, 260, 260, 260, 1, 245, 
	246, 247, 248, 292, 260, 292, 245, 260, 
	260, 260, 260, 1, 245, 246, 247, 248, 
	293, 260, 293, 245, 260, 260, 260, 260, 
	1, 245, 246, 247, 248, 294, 260, 294, 
	245, 260, 260, 260, 260, 1, 245, 246, 
	247, 248, 295, 260, 295, 245, 260, 260, 
	260, 260, 1, 245, 246, 247, 248, 279, 
	260, 279, 245, 260, 260, 260, 260, 1, 
	245, 246, 247, 248, 296, 260, 296, 245, 
	260, 260, 260, 260, 1, 245, 246, 247, 
	248, 297, 260, 297, 245, 260, 260, 260, 
	260, 1, 245, 246, 247, 248, 298, 260, 
	298, 245, 260, 260, 260, 260, 1, 245, 
	246, 247, 248, 299, 260, 299, 245, 260, 
	260, 260, 260, 1, 245, 246, 247, 248, 
	279, 260, 279, 245, 260, 260, 260, 260, 
	1, 245, 246, 247, 248, 300, 260, 300, 
	245, 260, 260, 260, 260, 1, 245, 246, 
	247, 248, 279, 260, 279, 245, 260, 260, 
	260, 260, 1, 79, 301, 302, 79, 1, 
	250, 303, 304, 250, 1, 0
]

class << self
	attr_accessor :_spec_probe_trans_targs
	private :_spec_probe_trans_targs, :_spec_probe_trans_targs=
end
self._spec_probe_trans_targs = [
	2, 0, 35, 206, 3, 4, 5, 6, 
	7, 8, 9, 11, 14, 10, 12, 13, 
	15, 16, 17, 19, 22, 18, 20, 21, 
	23, 24, 25, 26, 27, 28, 29, 30, 
	32, 31, 33, 34, 36, 37, 38, 39, 
	40, 41, 42, 101, 103, 42, 43, 100, 
	101, 103, 106, 112, 174, 189, 193, 188, 
	194, 199, 204, 43, 44, 45, 46, 92, 
	48, 45, 46, 48, 51, 87, 47, 49, 
	50, 52, 58, 274, 53, 55, 54, 274, 
	56, 57, 59, 60, 61, 62, 63, 64, 
	66, 69, 88, 65, 67, 68, 70, 71, 
	72, 73, 74, 75, 76, 77, 78, 79, 
	80, 81, 82, 84, 83, 85, 86, 89, 
	90, 91, 93, 99, 94, 95, 96, 98, 
	97, 100, 102, 104, 105, 107, 108, 109, 
	110, 111, 113, 114, 115, 116, 128, 130, 
	116, 117, 127, 128, 130, 133, 139, 142, 
	157, 161, 156, 162, 167, 172, 117, 118, 
	81, 82, 119, 84, 120, 126, 121, 122, 
	123, 125, 124, 127, 129, 131, 132, 134, 
	135, 136, 137, 138, 140, 141, 143, 147, 
	144, 145, 146, 148, 149, 150, 151, 152, 
	153, 154, 155, 156, 158, 159, 160, 163, 
	164, 165, 166, 168, 169, 170, 171, 173, 
	175, 179, 176, 177, 178, 180, 181, 182, 
	183, 184, 185, 186, 187, 188, 190, 191, 
	192, 195, 196, 197, 198, 200, 201, 202, 
	203, 205, 207, 208, 209, 210, 227, 229, 
	211, 226, 232, 238, 242, 257, 261, 256, 
	262, 267, 272, 211, 212, 275, 213, 218, 
	215, 214, 275, 216, 217, 219, 225, 220, 
	221, 222, 224, 223, 226, 228, 230, 231, 
	233, 234, 235, 236, 237, 239, 240, 241, 
	116, 128, 130, 243, 247, 244, 245, 246, 
	248, 249, 250, 251, 252, 253, 254, 255, 
	256, 258, 259, 260, 263, 264, 265, 266, 
	268, 269, 270, 271, 273, 53, 55, 213, 
	215
]

class << self
	attr_accessor :_spec_probe_trans_actions
	private :_spec_probe_trans_actions, :_spec_probe_trans_actions=
end
self._spec_probe_trans_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 7, 7, 7, 0, 1, 1, 
	0, 0, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 0, 0, 3, 3, 0, 
	3, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 5, 5, 5, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 9, 9, 9, 
	0, 1, 1, 0, 0, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 0, 0, 
	3, 3, 0, 3, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 0, 0, 15, 3, 0, 
	3, 0, 11, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	13, 13, 13, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0
]

class << self
	attr_accessor :spec_probe_start
end
self.spec_probe_start = 1;
class << self
	attr_accessor :spec_probe_first_final
end
self.spec_probe_first_final = 274;
class << self
	attr_accessor :spec_probe_error
end
self.spec_probe_error = 0;

class << self
	attr_accessor :spec_probe_en_probe
end
self.spec_probe_en_probe = 1;


# line 68 "lib/vorax/parser/grammars/probe_composite.rl"
					
# line 955 "lib/vorax/parser/grammars/probe_composite.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = spec_probe_start
end

# line 69 "lib/vorax/parser/grammars/probe_composite.rl"
					
# line 964 "lib/vorax/parser/grammars/probe_composite.rb"
begin
	_klen, _trans, _keys, _acts, _nacts = nil
	_goto_level = 0
	_resume = 10
	_eof_trans = 15
	_again = 20
	_test_eof = 30
	_out = 40
	while true
	_trigger_goto = false
	if _goto_level <= 0
	if p == pe
		_goto_level = _test_eof
		next
	end
	if cs == 0
		_goto_level = _out
		next
	end
	end
	if _goto_level <= _resume
	_keys = _spec_probe_key_offsets[cs]
	_trans = _spec_probe_index_offsets[cs]
	_klen = _spec_probe_single_lengths[cs]
	_break_match = false
	
	begin
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + _klen - 1

	     loop do
	        break if _upper < _lower
	        _mid = _lower + ( (_upper - _lower) >> 1 )

	        if data[p].ord < _spec_probe_trans_keys[_mid]
	           _upper = _mid - 1
	        elsif data[p].ord > _spec_probe_trans_keys[_mid]
	           _lower = _mid + 1
	        else
	           _trans += (_mid - _keys)
	           _break_match = true
	           break
	        end
	     end # loop
	     break if _break_match
	     _keys += _klen
	     _trans += _klen
	  end
	  _klen = _spec_probe_range_lengths[cs]
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + (_klen << 1) - 2
	     loop do
	        break if _upper < _lower
	        _mid = _lower + (((_upper-_lower) >> 1) & ~1)
	        if data[p].ord < _spec_probe_trans_keys[_mid]
	          _upper = _mid - 2
	        elsif data[p].ord > _spec_probe_trans_keys[_mid+1]
	          _lower = _mid + 2
	        else
	          _trans += ((_mid - _keys) >> 1)
	          _break_match = true
	          break
	        end
	     end # loop
	     break if _break_match
	     _trans += _klen
	  end
	end while false
	_trans = _spec_probe_indicies[_trans]
	cs = _spec_probe_trans_targs[_trans]
	if _spec_probe_trans_actions[_trans] != 0
		_acts = _spec_probe_trans_actions[_trans]
		_nacts = _spec_probe_actions[_acts]
		_acts += 1
		while _nacts > 0
			_nacts -= 1
			_acts += 1
			case _spec_probe_actions[_acts - 1]
when 0 then
# line 19 "lib/vorax/parser/grammars/probe_composite.rl"
		begin
@start_id = p; @pos_name_temp = p		end
when 1 then
# line 19 "lib/vorax/parser/grammars/probe_composite.rl"
		begin
@name_temp = data[@start_id...p]		end
when 2 then
# line 21 "lib/vorax/parser/grammars/probe_composite.rl"
		begin
@pointer = p; @kind = @kind_temp; @name = @name_temp; @pos_name = @pos_name_temp		end
when 3 then
# line 24 "lib/vorax/parser/grammars/probe_composite.rl"
		begin
 @kind_temp = :package_spec 		end
when 4 then
# line 30 "lib/vorax/parser/grammars/probe_composite.rl"
		begin
 @kind_temp = :package_body 		end
when 5 then
# line 36 "lib/vorax/parser/grammars/probe_composite.rl"
		begin
@kind = :type_spec; @name = @name_temp; @pos_name = @pos_name_temp		end
when 6 then
# line 39 "lib/vorax/parser/grammars/probe_composite.rl"
		begin
 @kind_temp = :type_body 		end
# line 1073 "lib/vorax/parser/grammars/probe_composite.rb"
			end # action switch
		end
	end
	if _trigger_goto
		next
	end
	end
	if _goto_level <= _again
	if cs == 0
		_goto_level = _out
		next
	end
	p += 1
	if p != pe
		_goto_level = _resume
		next
	end
	end
	if _goto_level <= _test_eof
	end
	if _goto_level <= _out
		break
	end
	end
	end

# line 70 "lib/vorax/parser/grammars/probe_composite.rl"
				end
				{:name => @name, :kind => @kind, :pointer => @pointer, :name_pos => @pos_name}
			end

    end

  end

end
