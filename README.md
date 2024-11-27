Ryan Steele - 100926075

PDF With Digrams and Pictures
https://drive.google.com/file/d/1juVdwAkY2WIMSl1aODcuJ5rndwpKMz2E/view?usp=drive_link

All Resources:
https://drive.google.com/drive/folders/1vWDNtRXiUjH2_gYyAv1GdbFYgpccmmWY?usp=sharing

Assignment 2 Deliverables:

Github: 
https://github.com/ryans11d2/CG-Project-1 

Release:
https://github.com/ryans11d2/CG-Project-1/releases 

Video:
https://youtu.be/FI8FQgCgvpg 

Presentation:
https://docs.google.com/presentation/d/1G7RFILbA45g7fk5r2kRwdEBDYVlmNqb0kibV2Mj_oRc/edit#slide=id.g31ac8de2105_0_0 


Assignment 1 Files

Github: 
https://github.com/ryans11d2/CG-Project-1 

Release:
https://github.com/ryans11d2/CG-Project-1/releases/tag/v1.0.0 

Slideshow: https://docs.google.com/presentation/d/142FOpR7z0Wllzvbdq_cSJwBbHT6ahu4wh11Pq1wGZhg/edit?usp=sharing 

Video:
https://youtu.be/MgLF8nyuwag 

Report:
https://docs.google.com/document/d/1fsTJLy9Jdd0lGcsc1a07hBH7ic7yrJinzlsPoj92z58/edit?tab=t.0 


Assignment 1 Deliverables:

Base
Dynamic Game Objects
Player
Search Lights
Bullets
Rotating Globe Hologram
Playable Main Character
Scene Objects
Walls, Floor & Doors
Search Lights & Lasers
Switch Boxes
Win/Lose Condition
Triggering the alarm will start a countdown, when the countdown reaches zero the player loses
Navigating to the end room, triggering the terminal, and returning to the start will trigger victory
 Visual Style
Glowing lights
Dark environment

Illumination
Simple Diffuse ()
Diffuse with Ambient (Obstacle Walls)
Simple Specular (Floor)

Colour Grading
Dark LUT (Cool)
Alarm LUT (Warm)
Camera LUT (Custom)
Shaders
Search Lights (Hologram)
Stencil (Walls & Doors)


Assignment 2 Deliverables:

Improvements
Better LUTs
Added textures to switches
Added normal-maps to textures
Wall shader improved
Globe shader improved (with replacement)
Laser shader improved

Textures
Room Walls
Switches
Floor
Decorative Button Panel
Decorative Light Switch
Decorative Speaker
Player (No Normal Map)
Globe (No Normal Map)
Screen (No Normal Map)
Obstacle Walls (No Texture)
Laser (No Texture)

Visual Effects (New)
Screen
TV Screens are placed around walls throughout the game, and add variation to the wall textures with some animation. The screen shader employs scrolling textures and decals for its effect. Greater detail can be found below.
![image](https://github.com/user-attachments/assets/792867c3-2beb-42c5-98e1-95f99e2c714d)

Globe
Uses a new shader, different from the original one, that uses texture scrolling and vertix extrusion. Greater detail can be found below.


External Resources:
LUT’s are modified versions of the NeutralLUT provided on Canvas.
Krita used for making textures and normal maps
Desmos Graphing Calculator used for soe diagrams
All shaders based on content from class

Explanations:


Wall Decoration:
To make the walls of the level more interesting, some decorative objects were made to be placed around the walls and add some variation to the rooms. The decorative objects use a shader based on the normal map shader provided in class, which uses an imputed normal-map image to determine the normal direction for a fragment.

This is a new addition that was not in assignment 1.

The Normal Map assigns each pixel its own normal based on an imputed normal-map texture. For lighting models, the different normal will change the angle of the reflected light and thus, the colour of the pixel, which gives the surface the appearance of bumps without changing the geometry.
![image](https://github.com/user-attachments/assets/139f0218-af1f-40e7-a68a-b5d725c45add)


Facility Wall:
Used as the walls for each room, made to look like the walls of a high tech science facility with wires and electrical boxes. Uses a stencil buffer that prevents fragments from drawing if they overlap with door stencil. Uses a pair of textures and normal maps, one for the main wall texture, and another overlay texture for tubes and wires hanging on the wall with a transparent background. The purpose is to set the environment of the game, a highly secure facility like you might see in a heist movie. First, the shader draws the overlay texture, then draws the main wall texture on fragments where the overlay texture has 0 alpha. A pair of normal maps are implemented in a similar way, with the purpose of adding texture to the wall and making the overlay wires stick out from the wall. The shader uses the alpha from the overlay texture to determine if a fragment will take on the normal from the main wall normal map or the overlay normal map. The main wall and overlay normals are multiplied by corresponding slider values from 0 to 1 so the amount the bumps appear to deviate from the wall can be fine tuned. The use of normal maps gives the wall a more realistic 3D look, even though it uses 2D textures. Because it uses a separate normal map for the main wall and overlay, the overlay texture can be switched out for another one easily to add different wall variations. The shader uses the bump-map code provided in the lecture notes as a base. The wall stencil buffer is taken from the stencil shader provided in class. An additional texture and bump-map are added and code is added in the surface function to determine what texture and normal-map to use based on the overlay transparency.

The main texture of the wall is gray, so it looks metallic and bland like a security facility. The wires overlaid are set to cool colours, green, blue, and purple, because warm colours are used for the security measures. To make the security systems stand out, the LUTs typically make warm colours more visible, and I didn’t want the colours on the wall to distract or interfere with the lasers and searchlights.

This has been improved from assignment 1, where it only used a simple texture shader with the stencil buffer. The wall was improved because adding normal mapping made them look better and improved the immersion of the world.

![image](https://github.com/user-attachments/assets/d4db76f4-1598-480f-b18e-084f0e06c49a)



Door:
The door is a hole through the facility walls that allow the player to see where the entrance to the next room is, and what’s inside it. The door shader is taken from lecture material, it is set to colour mask 0 with no diffuse colour or texture so it renders transparent, the render queue is set lower than the wall object (geometry - 1) and zwrite is off so it always draws in front of walls. The shader employs a stencil buffer that tells overlapping walls not to draw, leaving a visible hole to the other side of them. Paired with a script, the quad objects with a door stencil material will teleport the player into the next room on contact with the door objects. The script also makes the stencils invisible when the player is not in the same room, to prevent doors in other rooms from putting holes in all the walls.

This has not been changed from assignment 1, it worked sufficiently and did not need any adjustments to improve its look or function.

![image](https://github.com/user-attachments/assets/1158bfe9-9f67-43ef-b92c-a4848923539b)


Switch:
The job of a switch is to disable security systems for a duration when shot by the player. The switch is decorated with a circuit pattern that uses a bump map for texture. While the switch is off, it draws a red emission based on the time until it turns back on. The main texture and bump-map are determined using the bump-map shader provided in class. The shader then sets the colour mask to 0 and runs a second cgprogram based off the emission shader provided in class where it draws red emissions with alpha values based on the normal taken from the normal-map. This way the power of the emission is controlled by the switch script and reflects the time the player has before the switch and its connected components turn back on. The switch texture does not properly tile around its sides, but because the camera viewpoint only sees switches from straight ahead, the sides can’t be seen and the texture appears to seamlessly wrap around itself. Multiple cubes with the circuit texture are stacked on top of each other.

This has been improved from assignment 1. It now uses a completely different shader in the place of a simple rim lighting shader. This was improved so the switches could have a thematically appropriate look instead of being yellow boxes with a red glow.

Where the normals are not 0, a red emission is applied
![image](https://github.com/user-attachments/assets/9cd7004b-052d-4857-b3a4-1531d23b94da)

![switch demo](https://github.com/user-attachments/assets/9c07888a-74e8-413a-aaf6-171fcc7e966b)

Screen:
The purpose of the screen is to add decoration to the game scene. TV screens are positioned on walls around the level to add to the aesthetic of the game and make the rooms seem more visually interesting. For a touch of humor, all the screens display a logo bouncing around, inspired by the DVD logo, in front of a scrolling static texture. The shader is loosely based on the ambient shader provided in class, with elements of the scroll shader provided as well. The shader takes the position, normal, and texcoord from the vertex input and outputs position, color, normal direction, and three different UVs. A main UV is used for reference later in the script, as the other two are altered in ways that would mess up the calculations. The second UV is the decal UV, which can be scaled to make the decal texture bigger or smaller. The third UV is for the background texture, and is offset along the y axis based on the time. A draw region can be set using sliders that determines what coordinates of the decal texture should be drawn. Cutoff ranges can be set from the left, right, top, and bottom of the texture, and the decal will only be drawn inside those bounds, otherwise the background texture is drawn. The background texture is also automatically drawn where the decal texture has an alpha that is less than 1. The cutoff ranges are offset by the same values that the decal UV is, so when the decal is moved it doesn’t leave the draw region. The specific functions of this shader allow a part of an overlay texture to be isolated and move around, unlike the default texture offset settings that move the entire texture. The bouncing logo is moved by a script that changes the offset values.

This is a new addition for the final project. This was added to make the levels more interesting and add decoration to the environment.

![image](https://github.com/user-attachments/assets/7492762a-082d-456f-8924-4e5a74c4e598)


![tv screen](https://github.com/user-attachments/assets/38917ef8-ab6a-4ace-aad1-253c2f54e2f9)
![screen control demo](https://github.com/user-attachments/assets/ccf9ec8f-2847-4410-a17c-8c128b433fcf)



Spotlight:
Spotlights are a security system that will trigger the alarm when the player enters their radius. The spotlight is meant to look like a large circular searchlight, similar to a theater spotlight, used to search for and uncover intruders. The spotlight shader uses the hologram shader provided in class to give it the look of a large beam of bright light. The shader determines the emission and alpha of each fragment based on the dot product of its normal and the view direction.When the angle to the camera is sharper, the emission and alpha will be higher, lighting up the rim of the object. The brightness uses an exponential function to determine the rim colour instead of a linear one so the rim lighting will be more abrupt and appear more like a line along the edge than a colour spread across the surface. The shader sets its colour mask to 0, making it transparent wherever an emission and alpha have not been set. It also sets the render queue to transparent+1 because it would otherwise draw before switches and prevent them from being visible. The spotlight gameobject is accompanied by a quad using an alpha shader based off the one provided in class to display a circle on the ground where the spotlight is shining.

Only the render queue was changed from assignment 1 after the new switch shader was implemented because its function did not need to be changed or improved.

![image](https://github.com/user-attachments/assets/ae783223-e778-452e-a5d5-b3a481eee2ee)

![spotlight demo](https://github.com/user-attachments/assets/76da416f-e29f-44a9-8159-ad3e55a1859e)



Globe:
The globe is the terminal players have to reach to retrieve the objective so they can escape and win the game. It is meant to look like a high-tech interface you would see in a sci-fi movie, so it takes on a holographic look. The globe shader has two passes, one that uses vertex extrusion and texture scrolling based off of material provided in class to make an image of a spinning globe, and a second pass that applies the hologram shader provided in class to give the globe its high-tech look. In the first pass, the vertices of the model are multiplied by a scale slider, which shrinks its appearance. The texture coordinates referenced by the uv are offset on the x axis based on the time. For the second pass, the colour mask is set to 0 to make the hologram transparent. The emission and alpha of the hologram are set based on the dot product of the view direction and the fragments normal, where fragments with sharper angles have higher emission and alpha values, and fragments with wider angles become transparent. The hologram power can be adjusted so the emissions are spread out across a wider or narrower range. Because of the vertex extrusion, the spinning portion of the globe can be scaled down to fit inside the holographic sphere, which combined with the hologram power allows fine tuning of the shader to get the right look. 

This has been improved from assignment 1, where it used a different hologram shader with texture colours added to the albedo. This was improved so that the globe could be fine tuned for a better look.

The uv referenced by the shader to set the pixel colour is offset by the time, so as time goes on the colour of the pixel changes to a different part of the texture, which gives the appearance that the texture is moving across the object.
![image](https://github.com/user-attachments/assets/0196fb61-950b-46aa-bbd4-bbef1b0d7dac)

![globe demo](https://github.com/user-attachments/assets/24fea597-26ee-424d-b72c-cde8e669a781)

Obstacle Walls:
Obstacle Walls are walls inside rooms that force the path of the player. The walls use an ambient lighting model taken from class. The lighting model functions similarly to the one used in the floor shader, but with additional environmental light determined automatically by unity. The obstacle walls are meant to reflect light similar to the floor, so the environmental light is added to stop them from having dark faces that don’t look good.

This has not been changed from assignment 1. The ambient shader was replaced with a new one that does the same thing because the function did not need to be changed or improved.

The added ambient light mixed with the diffuse light prevents the shadows from being too dark.
![image](https://github.com/user-attachments/assets/30332eca-b1cb-4502-a860-a6703035c41b)


Floor:
The floor of every room is meant to look like a beat up metal floor to fit the theme. The floor uses a specular lighting shader that combines diffuse lighting, ambient environmental light, and paired with a texture and normal map that gives it a look with some uneven tiles and scratches that a heavily used floor would have. The main purpose of the floor shader is not only for aesthetics, but also to reflect the room lighting. When a room has no lights, or the alarm is on, the floor will reflect the light colour and add to the effect of those lights. The floor shader is based on the specular shader provided in class, but with accommodation to fit a texture and normal-map. The lighting model determines the colour of each fragment by adding the diffuse reflection, unity environmental light, and the specular reflection. The specular reflection is determined by the dot product of the camera angle and the normal direction, fragments with a smaller angle reflect the specular light colour less.

This has been improved from assignment 1 where it used an ambient diffuse shader. This was improved so it could take on a more realistic metallic and textured look that improves the look of the game.

The Specular lighting model adds the diffuse lighting, ambient environmental lighting, and elements of the holographic shader.
![image](https://github.com/user-attachments/assets/674fe512-be56-478b-b8ba-7589d98739de)


Laser:
The laser is one of the game's security systems that will trigger the alarm if crossed by the player. It is meant to replicate the look of security lasers in action movies. To make the laser feel more like a part of the world, rather than a straight line, the laser pulses on and off and its colour scrolls and oscillates between black and red along its length. The laser shader is based on the lighting model shaders provided in class, but uses almost nothing from them, taking only the position and texcoords from the vertex input and outputting them directly to the fragment. The colour of each fragment is determined by a sine function that oscillates between full and black offset by the time and texture coordinate, and another sine function that oscillates between full and black based on the time. The combination of the two functions gives the laser the look of scrolling coloured dots flashing on and off.

This uses a new original shader instead of the specular shader it used for assignment 1. This was changed to give the lasers some animation that improves the look of the game.

Base Colour:
c(x) =|Asin(B(x-C)) + D| 
y = The colour value of the fragment (rgb * y)
x = time
A (amplitude) = Colour, the colour will be at its full value at the amplitude
B (frequency) = Stretch, length of 1 period
C (horizontal shift) = Scroll, a value based on time that offsets the colour
D (vertical shift) = Shift, modifier for the value of the colour

Sets the colour based on vertex position and offsets it by time.

Pulse:
p(x) = |sin(b(x))|
y = Colour value of the fragment (rgb * )
x = time
b (frequency) = 

Multiplies the colour based on time to make it darker or brighter.

Final Colour:
f(x)=c*p
y = Colour of fragment
X = Time

This is the laser colour over time represented on a graph constructed using Desmos Graphing Calculator
![image](https://github.com/user-attachments/assets/d75403a0-073e-4840-b9b0-89c18e583d30)
The final colour value is represented by the red line, which displays its base colour value (represented by blue) offset by the time, multiplied by the pulse value (represented by green), which sets the final value between the base value and 0 multiplied by the time. In practice, the base colour would also be offset by its uv y position which is why the fragments have different colours that appear to move.

![laser demo 1](https://github.com/user-attachments/assets/a41e270d-9c4d-4b4d-ad0c-537aae84abd5)
![laser demo 2](https://github.com/user-attachments/assets/40fdf8a5-5cf7-4961-a1fc-3e79642ebf97)


Aim Laser:
The aim laser is a long cylinder connected to the player that points in the direction they are aiming. The laser allows the player to see where their shots are going to land so they can accurately move through the rooms. The shader employs features of the alpha and rim lighting shader provided in class, setting the emission and alpha of the cylinder from an imputed colour. The emission is easily visible and appears to glow, giving it the appearance of a laser. The alpha is multiplied by the normal y cubed, which has the emission appear to fade in and out of a line at the top of the cylinder. An animation changes the laser colour to yellow and fades it back to green when the player shoots as feedback.

This uses a new shader instead of the specular one from assignment 1. This was changed to make it look more like a real laser instead of a cylinder, which improves the look of the game.

![aim laser demo](https://github.com/user-attachments/assets/8183c3fb-704b-4892-896d-9755cac45df3)


Player Character:
The player character is the character controlled by the player that has to complete the game. Because I did not want to 3D model, the player instead uses a quad with a sprite texture. An alpha shader provided in class was used to put the character on the quad and give it a transparent background. The texture imputed is a sprite sheet with the tiling and offset variables adjusted to make the correct section of the sheet visible. The sprite sheet has a y component with all the different animation frames needed for the player, and an x component with the eight different directional versions of each frame. The offset of the texture is changed dynamically by a script so the correct tile of the sprite sheet is displayed. The x offset is determined by the angle from the player to the position where the mouse is pointing, and the y position is set by an animator.

This has not been changed from assignment 1 because its functions did not need to be changed or improved.

![image](https://github.com/user-attachments/assets/478a983e-992e-4a5c-b693-95eafb34d4a2)

![player demo](https://github.com/user-attachments/assets/9cc98107-f44b-4009-9a99-0fca180ef43b)




Colour Grading:

Warm LUT
When the alarm is active, a warm LUT adds a red colour to everything
Boosts the red channel for shadows, making the facility appear to glow red from the alarm lights
Clearly indicates that the alarm is on and the player needs to hurry. Greatly increases immersion.

![image](https://github.com/user-attachments/assets/4f51aa7a-a082-42f3-8075-5c67b4c696a9)


Cold LUT
When a room is dark, a cool LUT is used
Dark LUT, uses maximize channel, as most colours in the dark look blue, the colours of lasers and lights stick out a lot more
Darkens the scene and makes lasers and spotlights more visible, making it easier for the player to navigate and improving the look of the scene.

![image](https://github.com/user-attachments/assets/3c58491e-4608-4ff3-bb8d-e15363117214)


Custom LUT
When a room uses a security camera perspective, a green colour is added to everything
Normal LUT with translucent green drawn on top
The green LUT has “Generate Mipmap” enabled to add the effect of a low resolution screen
Adds to the immersion and aesthetic of the game

![image](https://github.com/user-attachments/assets/92ce56a6-2f41-478c-823b-d88afc4f4286)


The Colour grading shader takes a pixel colour from the screen and replaces it with a corresponding value from a 3D lookup table.
![image](https://github.com/user-attachments/assets/a741a710-0d33-4106-83f3-d937a89ecc89)


Toggling:
All textures and lighting effects are toggled on and off when the T key is pressed during the game. Toggling is controlled with a variable called “_Active” in every material, which is set between 0 and 1 by a texture manager script on each object. Inside the shaders, every lighting or texture colour is multiplied by _Active meaning that they will have their values set to 0 when the texture manager is toggled off and return to their typical values when it is toggled on. 


![image](https://github.com/user-attachments/assets/b8b72dac-6f4a-4c21-84d6-0451677e9cd8)
![image](https://github.com/user-attachments/assets/d64323ea-4400-46db-9e39-b6f853feb990)


