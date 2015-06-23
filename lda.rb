corpus = Array.new(){[]} #corpus[doc_index][token_index] = word
wd = []
allwd = []
k = 10
iterate = 1000
alpha = beta = 1.0

#Load File
File.open("kakaku_filtered.txt") do |f|
  while l = f.gets
    wd = l.split(" ")
    for w in wd do
      w.slice!(/_.*/)
    end
    wd.delete_if{|item| (item.length == 1 && !item=~/[\W_]/) || item=~/[!-~]|[Ａ-Ｚ]|[ａ-ｚ]|[０-９]|！|？/} #delete stopword
    corpus << wd
  end
end

#Initialization
lendoc = corpus.length
topic = Marshal.load(Marshal.dump(corpus)) #topic[doc_index][token_index] = topic_index
n_wz = Array.new(k){{}}                    #n_wz[z]["word"]:the number of times topic z is assigned to word w
n_dz = Array.new(lendoc){Array.new(k, 0)}  #n_dz[doc_index][topix_index]:the number of tokens with topic z in document d
n_z = Array.new(k, 0)                      #n_z[z] = ∑n_z,w
n_d = Array.new(lendoc, 0)                 #n_d[doc_index] = ∑n_d,z

for m in 0..lendoc-1
  for i in 0..corpus[m].length-1
    z = rand(k)
    topic[m][i] = z
    if n_wz[z].key?(corpus[m][i])
      n_wz[z][corpus[m][i]] += 1
    else
      n_wz[z][corpus[m][i]] = 1
    end
    n_dz[m][z] += 1
    n_d[m] += 1
    n_z[z] += 1
    allwd << corpus[m][i]
  end
end

allwd.uniq!
v = allwd.length #v:the number of word types

#Main Algorithm
for n in 0..iterate
  for m in 0..lendoc-1
    for i in 0..corpus[m].length-1
      z = topic[m][i]
      n_wz[z][corpus[m][i]] -= 1
      n_dz[m][z] -= 1
      n_d[m] -= 1
      n_z[z] -= 1
      temp = 0.0
      for j in 0..k-1
        if n_wz[j].key?(corpus[m][i])
          p_z_molecule = (n_wz[j][corpus[m][i]] + beta) * (n_dz[m][j] + alpha).to_f
        else
          p_z_molecule = beta * (n_dz[m][j] + alpha).to_f
        end
        p_z_denominator = (n_z[j] + beta*v) * (n_d[m] + alpha*k).to_f
        p_z = p_z_molecule / p_z_denominator
        if temp < p_z
          temp = p_z
          ztemp = j
        end
      end
      topic[m][i] = z
      n_wz[z][corpus[m][i]] += 1
      n_dz[m][z] += 1
      n_d[m] += 1
      n_z[z] += 1
    end
  end
end

#Output
resultary = Array.new(10)
for z in 0..k-1
  result = {}
  puts "z=#{z}------------------------------------------------"
  for m in 0..lendoc-1
    for i in 0..corpus[m].length-1
      if topic[m][i] == z
        e = (n_wz[z][corpus[m][i]] + beta) / (n_z[z] + beta*v).to_f
        result[corpus[m][i]] = e
      end
    end
  end
  resultary = result.sort{|key, val| val <=> key}[0..9]
  for res in resultary
    puts res
  end
end
