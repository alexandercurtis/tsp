# Travelling Salesman Problem

An algorithm using dynamic programming.

The travelling salesman problem is a well known example of an NP-complete problem. This does not mean that it can't be solved; rather it can't be solved in polynomial time.

A brute-force search could be used to solve the problem in time O(n!), however the dynamic programming approach take here provides a solution in O(n^2 . 2^n) which although not polynomial, is still an improvement on brute-force search.

## The algorithm

I implemented the algorithm from the lectures on Coursera on Algorithm Design by Tim Roughgarden.

The problem is defined in terms of finding the optimal solution from a number of sub-problems.

The subproblem here is:

For every vertex j in {v1,v2,...,vn} and every subset S of {v1,v2,...,vn} that contains v1 and j, let L(S,j) be the length of a shortest path from v1 to j that visits precisely the vertices of S exactly once.

Let k be the last vertex visited before j on this shortest path, then
 
L(S,j) = min ( k in S and k != j ) { L(S-{j},k) + ckj }
where ckj is the distance (cost) from vertex k to vertex j.

We can proceed because the size of the sub problem is strictly smaller than the current problem (because |S-{j}| < |S|).


The computational saving here is that although we keep track of the vertices visited in each subproblem, we don't track the order in which they are visited.


## The implementation

I chose Ruby as I haven't written anything in Ruby before and wanted to learn. So this is my first Ruby program hence I'm sure it's pretty naive in its use of the language.

A is a 2D array used to store the results of the sub-problem, indexed by S and j. The array is pre-populated with base case values where j = v1. This has value 0 if S is {v1} and +Infinity otherwise.

I represent S using a bitmap, where bit 0 represents v1, bit 1 represent v2, etc.. To iterate through all values of S for a given size I use Gosper's Hack (which is really neat!) 

For each sub-problem size m in 2,3,...n I iterate through the relevant choices of S.
Then for each m, I iterate through each vertex j in S (excluding v1) and store in A the value L(S,j).

Once this is complete, a brute force search is performed over the values in A, each time adding the cost from the last vertex j back to v1, in order to find the solution with the shortest overall path.

The implementation returns the length of the shortest path, but it is straightforward to output the corresponding vertices by working back through the subproblems.

## To run

To run, simply use
    
    ruby tsp.rb
 
The input data is read from an accompanying text file, the name of which is hardcoded into the source :-P






