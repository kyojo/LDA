corpus = Array.new(){[]}
wd = []

k = 10
iterate = 10
alpha = beta = 1

#Load File
File.open("kakaku_filtered.txt") do |f|
  while l = f.gets
    wd = l.split(" ")
    for w in wd do
      w.slice!(/_.*/)
    end
    #stop word
    wd.delete_if{|item| (item.length == 1 && !item=~/[\W_]/) || item=~/[!-~]/}
    corpus << wd
  end
end

#Initialization
lendoc = corpus.length
topic = Marshal.load(Marshal.dump(corpus))
n_wz = Array.new(k){{}}
n_dz = Array.new(lendoc){Array.new(k, 0)}
n_z = Array.new(k, 0)
n_d = Array.new(lendoc, 0)

for m in 0..lendoc-1 do
  for i in 0..corpus[m].length-1 do
    z = rand(k-1)
    topic[m][i] = z
    if n_wz[z].key?(corpus[m][i])
      n_wz[z][corpus[m][i]] += 1
    else
      n_wz[z][corpus[m][i]] = 1
    end
    n_dz[m][z] += 1
    n_d[m] += 1
    n_z[z] += 1
  end
end

#Main Algorithm
for n in 0..iterate
  for m in 0..lendoc-1
    for i in 0..corpus[m].length-1
      z = topic[m][i]
      n_wz[z][corpus[m][i]] -= 1
      n_dz[m][z] -= 1
      n_d[m] -= 1
      n_z[z] -= 1
      
    end
  end
end
