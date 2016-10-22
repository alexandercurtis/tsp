puts "Traveling Salesman Problem"

# Read input file
f = File.new("testdata.1.txt")
line = f.gets
words = line.scan(/\d+/)
nCities = words[0].to_i
puts "nCities=#{nCities}"
cities = []
nReadCities = 0
while( line = f.gets )
  words = line.scan(/-?[\d.]+/)
  x = words[0].to_f
  y = words[1].to_f
  cities[nReadCities] = [x,y]
  nReadCities = nReadCities+1
end

for i in 1..nCities
  puts "City #{i} at #{cities[i-1]}"
end

def distance(cities,i,j)
  xi = cities[i-1][0]
  yi = cities[i-1][1]
  xj = cities[j-1][0]
  yj = cities[j-1][1]
  dx = xj-xi
  dy = yj-yi
  return Math.sqrt(dx*dx+dy*dy)
end

def gosper(mask,x)
  u = x & (-x & mask)
  v = (u + x) & mask
  if v==0
    return nil
  end
  return v + ((((v^x)&mask)/u)>>2)
end

# The algorithm
# -------------
# A is a 2D array of route from 1 to j using only nodes in S (and j of course)
# A is indexed by subsets S in {1,2,...,n} that contain 1 and destinations j in {1,2,...,n}
a = [] # 0-based
# Using bit 0 to represent node 1 in s, bit 1 for node 2 etc
# Thus presence of node n in S is established by S&(2**(n-1))!=0

mask = (2**(nCities))-1;

# Base case A[S,1] = (if S=={1} 0 else +infinity (because 1 would be included twice otherwise))
for s in 0..(2**nCities-1)
  a[s]=[]
  a[s][0] = nil
end
a[1][0] = 0


maskExcluding1 = (mask/2).to_i

for m in 2..nCities
# Start with rightmost m bits set (and ignore bit 1)
  sExcluding1 = (2**(m-1))-1  # e.g. m=4 2^3=8 8-1 = 7

  loop do
    s = sExcluding1*2 + 1

    for j in 1..nCities
      if (s&(2**(j-1))) != 0
        minnest = nil
        for k in 1..nCities
          if (s&(2**(k-1))) != 0 && k != j # k in s && k ≠ j
            notj = ~(2**(j-1))
            nots = s&(notj)&mask
            sofar1 = a[nots]
            ckj = distance(cities,k,j)
            if !sofar1.nil?
              sofar = sofar1[k-1]
              if !sofar.nil?
                contender = sofar + ckj
                if( minnest.nil? || contender < minnest )
                  minnest = contender
                end
              end
            end
          end
        end

        a[s][j-1] = minnest
      end # if in S
    end # for each j in S

    next_sExcluding1 = gosper(maskExcluding1,sExcluding1)
    sExcluding1 = next_sExcluding1
    break if( sExcluding1.nil? )
  end   # end For each subset S
end # for m=2,3,4,...,n


# Return min|j=2 to n| {A[{1,2,3,...,n},j] + Cj1}
result = nil
for j in 2..nCities
  route = a[(2**nCities)-1]
  if !route.nil? && !route[j-1].nil?
    # shortest path to j using all nodes is route[j-1]
    # cost of final leg is distance(cities,j,1)
    current = route[j-1] + distance(cities,j,1)
    if result.nil? || current < result
      result = current
    end
  end
end

puts "Shortest path is #{result}"
