local levels = {
  level1 = {
    bgImg = "good_scene01.png",
    board = {
      {{tileType=""},{tileType="stone"},{tileType="block",name="powercurve",rotation=180},{tileType=""},{tileType=""}},
      {{tileType=""},{tileType=""},{tileType="stone"},{tileType=""},{tileType="stone"}},
      {{tileType=""},{tileType=""},{tileType=""},{tileType=""},{tileType=""}},
      {{tileType=""},{tileType=""},{tileType="stone"},{tileType=""},{tileType="block", name="powercurve", rotation=0}},
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
    },
	solution = {
	  {position = {x=3,y=1}, name="powercurve",rotation=180},
	  {position = {x=4,y=1}, name="powercurve",rotation=0},
	  {position = {x=4,y=2}, name="powerstraight",rotation=0},
	  {position = {x=4,y=3}, name="powerstraight",rotation=0},
	  {position = {x=4,y=4}, name="powercurve",rotation=180},
	  {position = {x=5,y=4}, name="powercurve",rotation=0},
	  {position = {x=5,y=5}, name="powerstraight",rotation=0},
	}
  },
    level2 = {
    bgImg = "good_scene01.png",
    board = {
      {{tileType="stone"},{tileType="stone"},{tileType="block",name="powercurve",rotation=180},{tileType=""},{tileType=""}},
      {{tileType=""},{tileType=""},{tileType="stone"},{tileType=""},{tileType=""}},
      {{tileType=""},{tileType=""},{tileType=""},{tileType="stone"},{tileType=""}},
      {{tileType=""},{tileType="stone"},{tileType=""},{tileType="stone"},{tileType=""}},
      {{tileType="stone"},{tileType=""},{tileType=""},{tileType="stone"},{tileType=""}}
    },
    arrows = {
      -- {img="d_arrow.png",x=display.contentWidth/2-60,y=display.contentHeight-70,w=24, h=36}
      -- {img="u_arrow.png",x=display.contentWidth/2-60,y=30,w=24, h=36},
      {img="l_arrow.png",x=60,y=display.contentHeight/2,w=36, h=24},
      -- {img="r_arrow.png",x=display.contentWidth/2 + 60,y=display.contentHeight/2,w=36, h=24}
    },
    pieces = {
      {name="powercurve",count=2},{name="downstraight",count=8},
      {name="downcurve",count=5},{name="powerstraight",count=1}
    },
	solution = {
		{position = {x=3,y=1}, name="powercurve",rotation=180},
		{position = {x=4,y=1}, name="powercurve",rotation=0},
		{position = {x=4,y=2}, name="downcurve",rotation=180},
		{position = {x=5,y=2}, name="downcurve",rotation=0},
		{position = {x=1,y=3}, name="downstraight",rotation=90},
		{position = {x=2,y=3}, name="downstraight",rotation=90},
		{position = {x=3,y=3}, name="downcurve",rotation=0},
		{position = {x=5,y=3}, name="downstraight",rotation=0},
		{position = {x=3,y=4}, name="downstraight",rotation=0},
		{position = {x=5,y=4}, name="downstraight",rotation=0},
		{position = {x=3,y=5}, name="downcurve",rotation=180},
		{position = {x=4,y=5}, name="downstraight",rotation=90},
		{position = {x=5,y=5}, name="downcurve",rotation=90},
	}
  },
    level3 = {
    bgImg = "good_scene01.png",
    board = {
      {{tileType="stone"},{tileType=""},{tileType=""},{tileType=""},{tileType="stone"}},
      {{tileType=""},{tileType=""},{tileType=""},{tileType=""},{tileType=""}},
      {{tileType=""},{tileType=""},{tileType=""},{tileType=""},{tileType="block", name="downcurve", rotation=180}},
      {{tileType=""},{tileType="stone"},{tileType=""},{tileType="stone"},{tileType=""}},
      {{tileType=""},{tileType=""},{tileType=""},{tileType="stone"},{tileType="stone"}}
    },
    arrows = {
      {img="d_arrow.png",x=display.contentWidth/2-60,y=display.contentHeight-70,w=24, h=36}
      -- {img="u_arrow.png",x=display.contentWidth/2-60,y=30,w=24, h=36},
      {img="l_arrow.png",x=60,y=display.contentHeight/2,w=36, h=24},
      -- {img="r_arrow.png",x=display.contentWidth/2 + 60,y=display.contentHeight/2,w=36, h=24}
    },
    pieces = {
      {name="powercurve",count=0},{name="downstraight",count=0},
      {name="downcurve",count=8},{name="powerstraight",count=1}
    },
	solution = {
	  {position = {x=3,y=1}, name="downcurve", rotation=270},
	  {position = {x=4,y=1}, name="downcurve", rotation=0},
	  {position = {x=2,y=2}, name="downcurve", rotation=270},
	  {position = {x=3,y=2}, name="downcurve", rotation=90},
	  {position = {x=4,y=2}, name="downcurve", rotation=180},
	  {position = {x=5,y=2}, name="downcurve", rotation=0},
	  {position = {x=1,y=3}, name="powerstraight", rotation=90},
	  {position = {x=2,y=3}, name="downcurve", rotation=90},
	  {position = {x=5,y=3}, name="downcurve", rotation=180},
	}
  },
    level4 = {
    bgImg = "good_scene01.png",
    board = {
      {{tileType=""},{tileType=""},{tileType="stone"},{tileType="stone"},{tileType="stone"}},
      {{tileType="stone"},{tileType=""},{tileType=""},{tileType=""},{tileType="stone"}},
      {{tileType=""},{tileType=""},{tileType=""},{tileType="stone"},{tileType=""}},
      {{tileType="stone"},{tileType=""},{tileType="stone"},{tileType=""},{tileType="block", name="powerstraight", rotation=90}},
      {{tileType=""},{tileType="stone"},{tileType="stone"},{tileType=""},{tileType="stone"}}
    },
    arrows = {
      {img="d_arrow.png",x=display.contentWidth/2-60,y=display.contentHeight-70,w=24, h=36}
      {img="u_arrow.png",x=display.contentWidth/2-60,y=30,w=24, h=36},
      {img="l_arrow.png",x=60,y=display.contentHeight/2,w=36, h=24},
      -- {img="r_arrow.png",x=display.contentWidth/2 + 60,y=display.contentHeight/2,w=36, h=24}
    },
    pieces = {
      {name="powercurve",count=0},{name="downstraight",count=1},
      {name="downcurve",count=8},{name="powerstraight",count=2}
    },
	solution = {
	  {position = {x=1,y=1}, name = "downcurve", rotation=180},
	  {position = {x=2,y=1}, name = "downcurve", rotation=0},
	  {position = {x=2,y=2}, name = "downcurve", rotation=180},
	  {position = {x=3,y=2}, name = "downcurve", rotation=0},
	  {position = {x=3,y=3}, name = "downstraight", rotation=0},
	  {position = {x=3,y=4}, name = "downcurve", rotation=180},
	  {position = {x=4,y=4}, name = "powerstraight", rotation=90},
	  {position = {x=5,y=4}, name = "powerstraight", rotation=90},
	  
	}
  },
    level5 = {
    bgImg = "good_scene01.png",
    board = {
      {{tileType=""},{tileType="stone"},{tileType=""},{tileType="stone"},{tileType="stone"}},
      {{tileType=""},{tileType=""},{tileType=""},{tileType=""},{tileType=""}},
      {{tileType="stone"},{tileType=""},{tileType=""},{tileType="stone"},{tileType=""}},
      {{tileType=""},{tileType=""},{tileType="stone"},{tileType=""},{tileType=""}},
      {{tileType="stone"},{tileType="stone"},{tileType="block", name="downcurve", rotation=270},{tileType=""},{tileType="stone"}}
    },
    arrows = {
      -- {img="d_arrow.png",x=display.contentWidth/2-60,y=display.contentHeight-70,w=24, h=36}
      {img="u_arrow.png",x=display.contentWidth/2-60,y=30,w=24, h=36},
      {img="l_arrow.png",x=60,y=display.contentHeight/2,w=36, h=24},
      -- {img="r_arrow.png",x=display.contentWidth/2 + 60,y=display.contentHeight/2,w=36, h=24}
    },
    pieces = {
      {name="powercurve",count=0},{name="downstraight",count=1},
      {name="downcurve",count=3},{name="powerstraight",count=3}
    },
	solution = {
	  {position = {x=1,y=1}, name = "downcurve", rotation=0},
	  {position = {x=1,y=2}, name = "downcurve", rotation=180},
	  {position = {x=2,y=2}, name = "downcurve", rotation=0},
	  {position = {x=3,y=2}, name = "downcurve", rotation=270},
	  {position = {x=4,y=2}, name = "downstraight", rotation=90},
	  {position = {x=5,y=2}, name = "powercurve", rotation=0},
	  {position = {x=2,y=3}, name = "downcurve", rotation=180},
	  {position = {x=3,y=3}, name = "downcurve", rotation=90},
	  {position = {x=5,y=3}, name = "powerstraight", rotation=0},
	  {position = {x=4,y=4}, name = "downcurve", rotation=270},
	  {position = {x=5,y=4}, name = "powercurve", rotation=90},
	  {position = {x=3,y=5}, name = "downcurve", rotation=270},
	  {position = {x=4,y=5}, name = "downcurve", rotation=90},
	}
  },
    level6 = {
    bgImg = "good_scene01.png",
    board = {
      {{tileType=""},{tileType=""},{tileType=""},{tileType=""},{tileType=""}},
      {{tileType=""},{tileType=""},{tileType="stone"},{tileType=""},{tileType=""}},
      {{tileType="stone"},{tileType=""},{tileType="stone"},{tileType="stone"},{tileType=""}},
      {{tileType=""},{tileType=""},{tileType="stone"},{tileType=""},{tileType="block", name="powercurve", rotation=180}},
      {{tileType=""},{tileType="stone"},{tileType=""},{tileType=""},{tileType="stone"}}
    },
    arrows = {
      -- {img="d_arrow.png",x=display.contentWidth/2-60,y=display.contentHeight-70,w=24, h=36}
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