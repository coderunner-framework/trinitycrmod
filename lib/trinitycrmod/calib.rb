
class Calib
  def self.analyse_file(filename)
    str = File.read(filename)
    str.sub!(/calibra.*\s+/, '')
    cal = $~[0]
    strs = str.split(/(?=reduced_qflux)/); strs.shift
    return strs.map{|s| new_from_string(cal,s)}
  end
  def self.new_from_string(cal,str)
    pp str
    cal = cal.sub(/cal\w+/,'').split(/\s+/).delete_if{|s| s=~/\A\s*\Z/}.map{|s| s.to_i}
    hash = str.scan(
      /((?:(?:reduced|full)_[pq]flux)|[pq]flux factor)([\deE\s.+-]+)/
    ).inject({}){|h,(k,v)| 
      arr = v.split(/\s+/).delete_if{|s| s=~/\A\s*\Z/}.map{|s| s.to_f}
      h[k.gsub(/ /, '_')]=arr.pieces(arr.size>cal.size*3?2:3); h}
    pp hash
    hash[:calibration_jobs] = cal
    new(hash)
  end
  attr_accessor :calibration_jobs
  def initialize(hash)
    hash.each{|k,v| instance_variable_set("@".to_sym + k, v)}
  end
  def pflux_graphkit(i)
    #k = (0..0).to_a.map{|i|
    k = GraphKit.quick_create([@calibration_jobs, raw_pflux_factor(i)], [(0...(@pflux_factor[i].size)).to_a, @pflux_factor[i]])
    #}.sum
    k.data.each{|dk| dk.gp.with = 'lp'}
    k.data[1].title = 'factor'
    k
  end
  def qflux_graphkit(i)
    #k = (0..0).to_a.map{|i|
    k = GraphKit.quick_create([@calibration_jobs, raw_qflux_factor(i)], [(0...(@qflux_factor[i].size)).to_a, @qflux_factor[i]])
    #}.sum
    k.data.each{|dk| dk.gp.with = 'lp'}
    k.data[1].title = 'factor'
    k
  end
  def raw_qflux_factor(i)
    (@full_qflux[i].to_gslv/@reduced_qflux[i].to_gslv).to_a
  end
  def raw_pflux_factor(i)
    (@full_pflux[i].to_gslv/@reduced_pflux[i].to_gslv).to_a
  end
end
