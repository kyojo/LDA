corpus = Array.new(){[]}
topic = Array.new(){[]}
n_wz = Array.new(){[]}
n_dz = Array.new(){[]}
n_z = []
n_d = []
wd = []
k = 5

alpha = beta = 2

#Load File
File.open("kakaku_filtered.txt") do |f|
  while l = f.gets
    wd = l.split(" ")
    for w in wd do
      w.slice!(/_.*/)
    end
    corpus << wd
  end
end

#Initialization
for ary in corpus do
  for elm in ary do
    puts rand
  end
end

