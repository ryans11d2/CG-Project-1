External Resources:
LUT’s are modified versions of the NeutralLUT provided on Canvas.
Krita used for making textures and normal maps
Desmos Graphing Calculator used for soe diagrams
All shaders based on content from class

Explanations:

Warm LUT
When the alarm is active, a warm LUT adds a red colour to everything
Boosts the red channel for shadows, making the facility appear to glow red from the alarm lights
Cold LUT
When a room is dark, a cool LUT is used
Dark LUT, uses maximize channel, as most colours in the dark look blue, the colours of lasers and lights stick out a lot more

Custom LUT
When a room uses a security camera perspective, a green colour is added to everything
Normal LUT with translucent green drawn on top
The green LUT has “Generate Mipmap” enabled to add the effect of a low resolution screen

Implementation:
Use in game
How it’s made
Purpose
Deviation from class
Diagram if necessary
Facility Wall:
Used as the walls for each room, made to look like the walls of a high tech science facility with wires and electrical boxes. Uses a stencil buffer that prevents pixels from drawing if they overlap with door stencil. Uses a pair of textures and normal maps, one for the main wall texture, and another overlay texture for tubes and wires hanging on the wall with a transparent background. The purpose is to set the environment of the game, a highly secure facility like you might see in a heist movie. First, the shader draws the overlay texture, then draws the main wall texture on pixels where the overlay texture has 0 alpha. A pair of normal maps are implemented in a similar way, with the purpose of adding texture to the wall and making the overlay wires stick out from the wall. The shader uses the alpha from the overlay texture to determine if a pixel will take on the normal from the main wall normal map or the overlay normal map. The main wall and overlay normals are multiplied by corresponding slider values from 0 to 1 so the amount the bumps appear to deviate from the wall can be fine tuned. The use of normal maps gives the wall a more realistic 3D look, even though it uses 2D textures. Because it uses a separate normal map for the main wall and overlay, the overlay texture can be switched out for another one easily to add different wall variations. The shader uses the bump-map code provided in the lecture notes as a base. The wall stencil buffer is taken from the stencil shader provided in class. An additional texture and bump-map are added and code is added in the surface function to determine what texture and normal-map to use based on the overlay transparency.

The main texture of the wall is gray, so it looks metallic and bland like a security facility. The wires overlaid are set to cool colours, green, blue, and purple, because warm colours are used for the security measures. To make the security systems stand out, the LUTs typically make warm colours more visible, and I didn’t want the colours on the wall to distract or interfere with the lasers and searchlights.

Door:
The door is a hole through the facility walls that allow the player to see where the entrance to the next room is, and what’s inside it. The door shader is taken from lecture material, it is set to colour mask 0 with no diffuse colour or texture so it renders transparent, and zwrite is off so it always draws in front of walls. The shader employs a stencil buffer that tells overlapping walls not to draw, leaving a visible hole to the other side of them. Paired with a script, the quad objects with a door stencil material will teleport the player into the next room on contact with the door objects. The script also makes the stencils invisible when the player is not in the same room, to prevent doors in other rooms from putting holes in all the walls.

Switch:
The job of a switch is to disable security systems for a duration when shot by the player. The switch is decorated with a circuit pattern that uses a bump map for texture. While the switch is off, it draws a red emission based on the time until it turns back on. The main texture and bump-map are determined using the bump-map shader provided in class. The shader then sets the colour mask to 0 and runs a second cgprogram based off the emission shader provided in class where it draws red emissions with alpha values based on the normal taken from the normal-map. This way the power of the emission is controlled by the switch script and reflects the time the player has before the switch and its connected components turn back on. The switch texture does not properly tile around its sides, but because the camera viewpoint only sees switches from straight ahead, the sides can’t be seen and the texture appears to seamlessly wrap around itself. Multiple cubes with the circuit texture are stacked on top of each other.

Screen:
The purpose of the screen is to add decoration to the game scene. TV screens are positioned on walls around the level to add to the aesthetic of the game and make the rooms seem more visually interesting. For a touch of humor, all the screens display a logo bouncing around, inspired by the DVD logo, in front of a scrolling static texture. The shader is loosely based on the ambient shader provided in class, with elements of the scroll shader provided as well. The shader takes the position, normal, and texcoord from the vertex input and outputs position, color, normal direction, and three different UVs. A main UV is used for reference later in the script, as the other two are altered in ways that would mess up the calculations. The second UV is the decal UV, which can be scaled to make the decal texture bigger or smaller. The third UV is for the background texture, and is offset along the y axis based on the time. A draw region can be set using sliders that determines what coordinates of the decal texture should be drawn. Cutoff ranges can be set from the left, right, top, and bottom of the texture, and the decal will only be drawn inside those bounds, otherwise the background texture is drawn. The background texture is also automatically drawn where the decal texture has an alpha that is less than 1. The cutoff ranges are offset by the same values that the decal UV is, so when the decal is moved it doesn’t leave the draw region. The specific functions of this shader allow a part of an overlay texture to be isolated and move around, unlike the default texture offset settings that move the entire texture. The bouncing logo is moved by a script that changes the offset values.

Globe:
The globe is the terminal players have to reach to retrieve the objective so they can escape and win the game. It is meant to look like a high-tech interface you would see in a sci-fi movie, so it takes on a holographic look. The globe shader has two passes, one that uses vertex extrusion and texture scrolling based off of material provided in class to make an image of a spinning globe, and a second pass that applies the hologram shader provided in class to give the globe its high-tech look. In the first pass, the vertices of the model are multiplied by a scale slider, which shrinks its appearance. The texture coordinates referenced by the uv are offset on the x axis based on the time. For the second pass, the colour mask is set to 0 to make the hologram transparent. The emission and alpha of the hologram are set based on the dot product of the view direction and the pixels normal, where pixels with sharper angles have higher emission and alpha values, and pixels with wider angles become transparent. The hologram power can be adjusted so the emissions are spread out across a wider or narrower range. Because of the vertex extrusion, the spinning portion of the globe can be scaled down to fit inside the holographic sphere, which combined with the hologram power allows fine tuning of the shader to get the right look. 

Floor:
The floor of every room is meant to look like a beat up metal floor to fit the theme. The floor uses a simple diffuse shader paired with a texture and normal map that gives it a look with some uneven tiles and scratches that a heavily used floor would have. The main purpose of the floor shader is not only for aesthetics, but also to reflect the room lighting. When a room has no lights, or the alarm is on, the floor will reflect the light colour and add to the effect of those lights. The floor shader is based on the lambert shader provided in class, but with accommodation to fit a texture and normal-map. The lighting model determines the colour of each pixel based on its vertex colour, corresponding texture uv, and the base colour added on top. The vertex colour is determined using the light colour and the dot product of the vertex normal and the light direction.

Obstacle Walls:
Obstacle Walls are walls inside rooms that force the path of the player. The walls use an ambient lighting model taken from class. The lighting model functions similarly to the one used in the floor shader, but with additional environmental light determined automatically by unity. The obstacle walls are meant to reflect light similar to the floor, so the environmental light is added to stop them from having dark faces that don’t look good.

Laser:
The laser is one of the game's security systems that will trigger the alarm if crossed by the player. It is meant to replicate the look of security lasers in action movies. To make the laser feel more like a part of the world, rather than a straight line, the laser pulses on and off and its colour scrolls and oscillates between black and red along its length. The laser shader is based on the lighting model shaders provided in class, but uses almost nothing from them, taking only the position and texcoords from the vertex input and outputting them directly to the fragment. The colour of each pixel is determined by a sine function that oscillates between full and black offset by the time and texture coordinate, and another sine function that oscillates between full and black based on the time. The combination of the two functions gives the laser the look of scrolling coloured dots flashing on and off.

Base Colour:
c(x) =abs(Asin(B(x-C)) + D) 
y = The colour value of the pixel (rgb * y)
x = time
A (amplitude) = Colour, the colour will be at its full value at the amplitude
B (frequency) = Stretch, length of 1 period
C (horizontal shift) = Scroll, a value based on time that offsets the colour
D (vertical shift) = Shift, modifier for the value of the colour

Sets the colour based on vertex position and offsets it by time.

Pulse:
p(x) = abs(sin(b(x)))
y = Colour value of the pixel (rgb * )
x = time
b (frequency) = 

Multiplies the colour based on time to make it darker or brighter.

Final Colour:
f(x)=c*p
y = Colour of pixel
X = Time

Aim Laser:
The aim laser is a long cylinder connected to the player that points in the direction they are aiming. The laser allows the player to see where their shots are going to land so they can accurately move through the rooms. The shader employs features of the alpha and rim lighting shader provided in class, setting the emission and alpha of the cylinder from an imputed colour. The emission is easily visible and appears to glow, giving it the appearance of a laser. The alpha is multiplied by the normal y cubed, which has the emission appear to fade in and out of a line at the top of the cylinder.

