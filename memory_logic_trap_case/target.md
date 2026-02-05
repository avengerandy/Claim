Is the following solution able to correctly solve this problem? Please investigate whether it is functional or not, and explain the reasons behind your conclusion.

695. Max Area of Island
Medium
Topics
premium lock iconCompanies

You are given an m x n binary matrix grid. An island is a group of 1's (representing land) connected 4-directionally (horizontal or vertical.) You may assume all four edges of the grid are surrounded by water.

The area of an island is the number of cells with a value 1 in the island.

Return the maximum area of an island in grid. If there is no island, return 0.



Example 1:

Input: grid = [[0,0,1,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,0,1,1,1,0,0,0],[0,1,1,0,1,0,0,0,0,0,0,0,0],[0,1,0,0,1,1,0,0,1,0,1,0,0],[0,1,0,0,1,1,0,0,1,1,1,0,0],[0,0,0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,1,1,1,0,0,0],[0,0,0,0,0,0,0,1,1,0,0,0,0]]
Output: 6
Explanation: The answer is not 11, because the island must be connected 4-directionally.

Example 2:

Input: grid = [[0,0,0,0,0,0,0,0]]
Output: 0



Constraints:

    m == grid.length
    n == grid[i].length
    1 <= m, n <= 50
    grid[i][j] is either 0 or 1.

class Solution:
    def maxAreaOfIsland(self, grid: List[List[int]]) -> int:
        self.grid = grid
        ans = 0
        for i in range(len(self.grid)):
            for j in range(len(self.grid[i])):
                if self.grid[i][j] == 1:
                    area = self.dfs(i, j, 2) - 2
                    ans = max(area, ans)

        return ans

    def dfs(self, i: int, j: int, step: int) -> int:
        if i < 0 or j < 0:
            return step
        if i > len(self.grid) - 1 or j > len(self.grid[0]) - 1:
            return step
        if self.grid[i][j] != 1:
            return step
        self.grid[i][j] = step
        step = step + 1
        step = self.dfs(i + 1, j, step)
        step = self.dfs(i - 1, j, step)
        step = self.dfs(i, j + 1, step)
        return self.dfs(i, j - 1, step)
