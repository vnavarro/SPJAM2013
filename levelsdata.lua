local levels = {
  level1 = {
    bgImg = "good_scene01.png",
    board = {
      {{tileType=""},{tileType="stone"},{tileType="block",name="powercurve",rotation=180},{tileType=""},{tileType=""}},
      {{tileType=""},{tileType=""},{tileType="stone"},{tileType=""},{tileType="stone"}},
      {{tileType=""},{tileType=""},{tileType=""},{tileType=""},{tileType=""}},
      {{tileType=""},{tileType=""},{tileType="stone"},{tileType=""},{tileType=""}},
      {{tileType=""},{tileType="stone"},{tileType=""},{tileType="stone"},{tileType=""}}
    },
    arrows = {
      {img="d_arrow.png",x=display.contentWidth/2-60,y=display.contentHeight-70,w=24, h=36}
      -- {img="u_arrow.png",x=display.contentWidth/2-60,y=30,w=24, h=36},
      -- {img="l_arrow.png",x=60,y=display.contentHeight/2,w=36, h=24},
      -- {img="r_arrow.png",x=display.contentWidth/2 + 60,y=display.contentHeight/2,w=36, h=24}
    },
    pieces = {
      {name="powercurve",count=4},{name="downstraight",count=0},
      {name="downcurve",count=0},{name="powerstraight",count=5}
    }
  },
}

return levels