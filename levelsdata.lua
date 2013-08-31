local levels = {
  level1 = {
    bgImg = "good_scene01.png",
    board = {
      {{tileType=""},{tileType="stone",x=1,y=2},{tileType="block",name="powercurve",rotation=180},{tileType=""},{tileType=""}},
      {{tileType=""},{tileType=""},{tileType="stone"},{tileType=""},{tileType="stone"}},
      {{tileType=""},{tileType=""},{tileType=""},{tileType=""},{tileType=""}},
      {{tileType=""},{tileType=""},{tileType="stone"},{tileType=""},{tileType=""}},
      {{tileType=""},{tileType="stone"},{tileType=""},{tileType="stone"},{tileType=""}}
    },
    arrows = "d_arrow.png",
    pieces = {
      {name="powercurve",count=4},{name="downstraight",count=0},
      {name="downcurve",count=0},{name="powerstraight",count=5}
    }
  },
}

return levels