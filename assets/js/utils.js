/*
Utility functions for front-end.
Import as:
  import { function_name } from 'utils'
*/

export const SYNERGY_LINK = 'https://gamepedia.cursecdn.com/enterthegungeon_gamepedia/d/de/Synergy.png?version=1f711a64cba5050db214669860d9d410'

const QUALITY_OBJ = {
  "S": 'https://gamepedia.cursecdn.com/enterthegungeon_gamepedia/8/8b/1S_Quality_Item.png?version=40a22e5d15d51edf8172d87fc8288f9f',
  "A": 'https://gamepedia.cursecdn.com/enterthegungeon_gamepedia/9/9c/A_Quality_Item.png?version=24c0812d903d9ffb91704eb9ec8c4e5b',
  "B": 'https://gamepedia.cursecdn.com/enterthegungeon_gamepedia/f/f3/B_Quality_Item.png?version=99613a5f83c53195e09b42773b351676',
  "C": 'https://gamepedia.cursecdn.com/enterthegungeon_gamepedia/b/bd/C_Quality_Item.png?version=3f82a0b3849e9989060cbd03062b8780',
  "D": 'https://gamepedia.cursecdn.com/enterthegungeon_gamepedia/6/60/D_Quality_Item.png?version=484e9441ad7b8bba2da4079c5984bf99',
  "N": 'https://gamepedia.cursecdn.com/enterthegungeon_gamepedia/b/bf/N_Quality_Item.png?version=d62d33ff747269340a2786d0bc707fb9'
};

// debounce for requests to server
export const debounce = (fn, time) => {
  let timeout;

  return function() {
    const functionCall = () => fn.apply(this, arguments);

    clearTimeout(timeout);
    timeout = setTimeout(functionCall, time);
  }
};

// function to return the quality image URL from
export const getQualityImage = (quality) => {
  return QUALITY_OBJ[quality];
};
