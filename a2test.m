%A2
clear all;
close all;
clc;

%% robot set up
%Kinova spherical 7dof DH Parameters
Kinova=Kinovarobot7;
display('Kinova Robot Loaded')

%% Load RobotExtinguisher for collision detection
    [faceData,vertexData] = plyread('extinguisher.ply','tri');
    L1 = Link('alpha',-pi/2,'a',0,'d',0.3,'offset',0);
    RobotExtinguisher = SerialLink(L1,'name','fire extinguisher');
    RobotExtinguisher.faces = {faceData,[]};
    RobotExtinguisher.points = {vertexData,[]};
    REdefault=[-1.7,0,0];
    RobotExtinguisher.base= transl(REdefault);

    plot3d(RobotExtinguisher,0,'workspace',[ -2, 2, -2, 2, -0.01, 4])
    
display('robot extinguisher loaded')


camlight;
axis equal;
view(45,45);
hold on

%% load background and floor
LoadBackground;

%% load gui
gui=appgui;
guibool= gui.EStopButn;
Resume = gui.ResumeButn;
Estopstatus = 0;
%% Load objects
                        % % Load Table % %
[f,v,data] = plyread('workbench.ply','tri');
tableVertexCount = size(v,1);
% Move center point to origin
midPoint = sum(v)/tableVertexCount;
tableVerts = v - repmat(midPoint,tableVertexCount,1);
% Create a transform to describe the location (at the origin, since it's centered
tablePose = eye(4);
% Scale the colours to be 0-to-1 (they are originally 0-to-255
vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
TableMesh_h = trisurf(f,v(:,1),v(:,2),v(:,3),'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','Flat');
% Move the pose forward and a slight and random rotation
tablePose = transl(1,0.25,0);
updatedPoints = [tablePose * [v,ones(tableVertexCount,1)]']';  
% Now update the Vertices
TableMesh_h.Vertices = updatedPoints(:,1:3);
drawnow();

                        % % Load E-stop % %
[ef,ev,edata] = plyread('StopButton.ply','tri');
eVertexCount = size(ev,1);
% Move center point to origin
midPoint = sum(ev)/eVertexCount;
eVerts = ev - repmat(midPoint,eVertexCount,1);
% Create a transform to describe the location (at the origin, since it's centered
ePose = eye(4);
% Scale the colours to be 0-to-1 (they are originally 0-to-255
vertexColours = [edata.vertex.red, edata.vertex.green, edata.vertex.blue] / 255;
eMesh_h = trisurf(ef,ev(:,1),ev(:,2),ev(:,3),'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','Flat');
% Move the pose forward and a slight and random rotation
ePose = transl(2,-0.4,0.9);
updatedPoints = [ePose * [ev,ones(eVertexCount,1)]']';  
% Now update the Vertices
eMesh_h.Vertices = updatedPoints(:,1:3);
drawnow();

             % % Load lightbars at (-1,-1), (-1,1.5), (3,-1), (3,1.5) % %
[barf,barv,bardata] = plyread('lightbarfin.ply','tri');
barmesh_h = PlaceObject('lightbarfin.ply',[-1,-1,1]);
barmesh_h = PlaceObject('lightbarfin.ply',[-1,1.5,1]);
barmesh_h = PlaceObject('lightbarfin.ply',[3,-1,1]);
barmesh_h = PlaceObject('lightbarfin.ply',[3,1.5,1]);


                        % % Load Pencil % %
[pf,pv,pdata] = plyread('pencil.ply','tri');
pencilVertexCount = size(pv,1);
% Move center point to origin
midPoint = sum(pv)/pencilVertexCount;
pencilVerts = pv - repmat(midPoint,pencilVertexCount,1);
% Create a transform to describe the location (at the origin, since it's centered
pencilPose = eye(4);
% Scale the colours to be 0-to-1 (they are originally 0-to-255
vertexColours = [pdata.vertex.red, pdata.vertex.green, pdata.vertex.blue] / 255;
pencilMesh_h = trisurf(pf,pv(:,1),pv(:,2),pv(:,3),'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','Flat');
% Move the pose forward and at slight and random rotation
pencilPose = transl(0.25,0,0.9);
updatedPoints = [pencilPose * [pv,ones(pencilVertexCount,1)]']';  
% Now update the Vertices
pencilMesh_h.Vertices = updatedPoints(:,1:3);
drawnow();

                        % % Load Hammer % %
[f,v,data] = plyread('hammer.ply','tri');
hammerVertexCount = size(v,1);
% Move center point to origin
midPoint = sum(v)/hammerVertexCount;
hammerVerts = v - repmat(midPoint,hammerVertexCount,1);
% Create a transform to describe the location (at the origin, since it's centered
hammerPose = eye(4);
% Scale the colours to be 0-to-1 (they are originally 0-to-255
vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
hammerMesh_h = trisurf(f,v(:,1),v(:,2),v(:,3),'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','Flat');
% Move the pose forward and at slight and random rotation
hammerPose = transl(0.5,0,0.9);
updatedPoints = [hammerPose * [v,ones(hammerVertexCount,1)]']';  
% Now update the Vertices
hammerMesh_h.Vertices = updatedPoints(:,1:3);
drawnow();

                        % % Load Wrench % %
[wf,wv,wdata] = plyread('wrench.ply','tri');
wrenchVertexCount = size(wv,1);
% Move center point to origin
midPoint = sum(wv)/wrenchVertexCount;
wrenchVerts = wv - repmat(midPoint,wrenchVertexCount,1);
% Create a transform to describe the location (at the origin, since it's centered
wrenchPose = eye(4);
% Scale the colours to be 0-to-1 (they are originally 0-to-255
vertexColours = [wdata.vertex.red, wdata.vertex.green, wdata.vertex.blue] / 255;
wrenchMesh_h = trisurf(wf,wv(:,1),wv(:,2),wv(:,3),'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','Flat');
% Move the pose forward and at slight and random rotation
wrenchPose = transl(0.7,0,0.9)*trotz(deg2rad(90));
updatedPoints = [wrenchPose * [wv,ones(wrenchVertexCount,1)]']';  
% Now update the Vertices
wrenchMesh_h.Vertices = updatedPoints(:,1:3);
drawnow();

                        % % Load BoxWrench % %
[bf,bv,bdata] = plyread('BoxWrench.ply','tri');
bwrenchVertexCount = size(bv,1);
% Move center point to origin
midPoint = sum(bv)/bwrenchVertexCount;
bwrenchVerts = bv - repmat(midPoint,bwrenchVertexCount,1);
% Create a transform to describe the location (at the origin, since it's centered
bwrenchPose = eye(4);
% Scale the colours to be 0-to-1 (they are originally 0-to-255
vertexColours = [bdata.vertex.red, bdata.vertex.green, bdata.vertex.blue] / 255;
bwrenchMesh_h = trisurf(bf,bv(:,1),bv(:,2),bv(:,3),'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','Flat');
% Move the pose forward and at slight and random rotation
bwrenchPose = transl(0.25,0.4,0.9)*trotz(deg2rad(90));
updatedPoints = [bwrenchPose * [bv,ones(bwrenchVertexCount,1)]']';  
% Now update the Vertices
bwrenchMesh_h.Vertices = updatedPoints(:,1:3);
drawnow();


[vr,fr,fn] = RectangularPrism([-1,-1,0], [3,1.5,2.5]);


display('Setup is complete')
pause(1)


%% Move robot & pencil
p1 = pencilPose;
p2 = transl(0.1,0.5,1.5);
p3 = transl(0.1,1.5,1.5)*trotx(deg2rad(15));

q0 = Kinova.model.getpos();
q1 = Kinova.model.ikcon(p1);
q2 = Kinova.model.ikcon(p2);
q3 = Kinova.model.ikcon(p3);

steps = 30;
s = lspb(0,1,steps); 
qMatrix = nan(steps,6); 

    
for i = 1:steps; 
    guibool=gui.EStopButn;
    
    if guibool==1
        Resume = gui.ResumeButn;
        display('Estop Button Pressed - Release Estop and Resume')
             while Resume == 0
                 Resume = gui.ResumeButn;
                 pause(0.5)
                 guibool=gui.EStopButn;
                 if guibool == 0
                     display('EStop Released - Press Resume to Contuinue')
                     pause(1)
                 end
                 if Resume == 1
                     display('Resuming')
                 end
              guibool=gui.EStopButn;
             end
    end
        
    Qmatrix(i,:)= (1-s(i))*q0 + s(i)*q1;
    Kinova.model.animate(Qmatrix(i,:))
    
    result = IsCollision(RobotExtinguisher,0,fr,vr,fn);
        if result>0
            display('collision detected')
            pause;
        end
end
    pause(0.1);

for i = 1:steps; 
    guibool=gui.EStopButn;
    
    if guibool==1
        Resume = gui.ResumeButn;
        display('Estop Button Pressed - Release Estop and Resume')
             while Resume == 0
                 Resume = gui.ResumeButn;
                 pause(0.5)
                 guibool=gui.EStopButn;
                 if guibool == 0
                     display('EStop Released - Press Resume to Contuinue')
                     pause(1)
                 end
                 if Resume == 1
                     display('Resuming')
                 end
              guibool=gui.EStopButn;
             end
    end
        
    Qmatrix(i,:)= (1-s(i))*q1 + s(i)*q2;
    Kinova.model.animate(Qmatrix(i,:))
    
    qmove = Kinova.model.getpos();
    pencilPose = Kinova.model.fkine(qmove);
    updatedPoints = [pencilPose * [pv,ones(pencilVertexCount,1)]']';
    % Now update the Vertices
    pencilMesh_h.Vertices = updatedPoints(:,1:3);
    drawnow();
    
    result = IsCollision(RobotExtinguisher,0,fr,vr,fn);
        if result>0
            display('collision detected')
            pause;
        end
end

for i = 1:steps
    guibool=gui.EStopButn;
    
    if guibool==1
        Resume = gui.ResumeButn;
        display('Estop Button Pressed - Release Estop and Resume')
             while Resume == 0
                 Resume = gui.ResumeButn;
                 pause(0.5)
                 guibool=gui.EStopButn;
                 if guibool == 0
                     display('EStop Released - Press Resume to Contuinue')
                     pause(1)
                 end
                 if Resume == 1
                     display('Resuming')
                 end
              guibool=gui.EStopButn;
             end
    end
        
     Qmatrix(i,:)= (1-s(i))*q2 + s(i)*q3;
     Kinova.model.animate(Qmatrix(i,:))
     
     qmove = Kinova.model.getpos();
     pencilPose = Kinova.model.fkine(qmove);
     updatedPoints = [pencilPose * [pv,ones(pencilVertexCount,1)]']';  
     % Now update the Vertices
     pencilMesh_h.Vertices = updatedPoints(:,1:3);
     drawnow();
     
     result = IsCollision(RobotExtinguisher,0,fr,vr,fn);
        if result>0
            display('collision detected')
            pause;
        end
end
pause(0.1);
  
%% Move robot & hammer & extinguisher
p1 = hammerPose;
p2 = transl(0.5,0.5,1.55);
p3 = transl(0.5,1.25,1.55)*trotx(deg2rad(90));

q0 = Kinova.model.getpos();
q1 = Kinova.model.ikcon(p1);
q2 = Kinova.model.ikcon(p2);
q3 = Kinova.model.ikcon(p3);



steps = 30;
s = lspb(0,1,steps); 
qMatrix = nan(steps,6);

goback=0;
for i = 1:steps; 
    guibool=gui.EStopButn;
    
    if guibool==1
        Resume = gui.ResumeButn;
        display('Estop Button Pressed - Release Estop and Resume')
             while Resume == 0
                 Resume = gui.ResumeButn;
                 pause(0.5)
                 guibool=gui.EStopButn;
                 if guibool == 0
                     display('EStop Released - Press Resume to Contuinue')
                     pause(1)
                 end
                 if Resume == 1
                     display('Resuming')
                 end
              guibool=gui.EStopButn;
             end
    end
        
    Qmatrix(i,:)= (1-s(i))*q0 + s(i)*q1;
    Kinova.model.animate(Qmatrix(i,:))
    
    
    result = IsCollision(RobotExtinguisher,0,fr,vr,fn);
    movet=[(-2+i*0.1),0,0];
    
        if result>0
            display('collision detected')
            goback=1;
            pause;
        end
    if goback>0
            RobotExtinguisher.base = transl(REdefault);
            RobotExtinguisher.animate(0);
        else
            RobotExtinguisher.base = transl(movet);     
            RobotExtinguisher.animate(0);
    end
    
    end
       pause(0.1); 

for i = 1:steps; 
    guibool=gui.EStopButn;
    
    if guibool==1
        Resume = gui.ResumeButn;
        display('Estop Button Pressed - Release Estop and Resume')
             while Resume == 0
                 Resume = gui.ResumeButn;
                 pause(0.5)
                 guibool=gui.EStopButn;
                 if guibool == 0
                     display('EStop Released - Press Resume to Contuinue')
                     pause(1)
                 end
                 if Resume == 1
                     display('Resuming')
                 end
              guibool=gui.EStopButn;
             end
    end
        
    Qmatrix(i,:)= (1-s(i))*q1 + s(i)*q2;
    Kinova.model.animate(Qmatrix(i,:))
    
    qmove = Kinova.model.getpos();
    hammerPose = Kinova.model.fkine(qmove);
    updatedPoints = [hammerPose * [v,ones(hammerVertexCount,1)]']';  
    % Now update the Vertices
    hammerMesh_h.Vertices = updatedPoints(:,1:3);
    drawnow();
    
    result = IsCollision(RobotExtinguisher,0,fr,vr,fn);
        if result>0
            display('collision detected')
            pause;
        end
    end
    
    pause(0.1);

for i = 1:steps;
    guibool=gui.EStopButn;
    
    if guibool==1
        Resume = gui.ResumeButn;
        display('Estop Button Pressed - Release Estop and Resume')
             while Resume == 0
                 Resume = gui.ResumeButn;
                 pause(0.5)
                 guibool=gui.EStopButn;
                 if guibool == 0
                     display('EStop Released - Press Resume to Contuinue')
                     pause(1)
                 end
                 if Resume == 1
                     display('Resuming')
                 end
              guibool=gui.EStopButn;
             end
    end
     Qmatrix(i,:)= (1-s(i))*q2 + s(i)*q3;
     Kinova.model.animate(Qmatrix(i,:))
     
     qmove = Kinova.model.getpos();
     hammerPose = Kinova.model.fkine(qmove);
     updatedPoints = [hammerPose * [v,ones(hammerVertexCount,1)]']';  
     % Now update the Vertices
     hammerMesh_h.Vertices = updatedPoints(:,1:3);
     drawnow();
     
     result = IsCollision(RobotExtinguisher,0,fr,vr,fn);
        if result>0
            display('collision detected')
            pause;
        end
    end
     pause(0.1);

%% Move robot & wrench
p1 = wrenchPose;
p2 = transl(0.1,0.5,1.7);
p3 = transl(0.1,1.6,1.7)*trotx(deg2rad(15));

q0 = Kinova.model.getpos();
q1 = Kinova.model.ikcon(p1);
q2 = Kinova.model.ikcon(p2);
q3 = Kinova.model.ikcon(p3);

steps = 30;
s = lspb(0,1,steps); 
qMatrix = nan(steps,6); 

for i = 1:steps; 
    guibool=gui.EStopButn;
    
    if guibool==1
        Resume = gui.ResumeButn;
        display('Estop Button Pressed - Release Estop and Resume')
             while Resume == 0
                 Resume = gui.ResumeButn;
                 pause(0.5)
                 guibool=gui.EStopButn;
                 if guibool == 0
                     display('EStop Released - Press Resume to Contuinue')
                     pause(1)
                 end
                 if Resume == 1
                     display('Resuming')
                 end
              guibool=gui.EStopButn;
             end
    end
    Qmatrix(i,:)= (1-s(i))*q0 + s(i)*q1;
    Kinova.model.animate(Qmatrix(i,:))
    
    pause(0.1);
end

for i = 1:steps; 
    guibool=gui.EStopButn;
    
    if guibool==1
        Resume = gui.ResumeButn;
        display('Estop Button Pressed - Release Estop and Resume')
             while Resume == 0
                 Resume = gui.ResumeButn;
                 pause(0.5)
                 guibool=gui.EStopButn;
                 if guibool == 0
                     display('EStop Released - Press Resume to Contuinue')
                     pause(1)
                 end
                 if Resume == 1
                     display('Resuming')
                 end
              guibool=gui.EStopButn;
             end
    end
    Qmatrix(i,:)= (1-s(i))*q1 + s(i)*q2;
    Kinova.model.animate(Qmatrix(i,:))
    
    qmove = Kinova.model.getpos();
    wrenchPose = Kinova.model.fkine(qmove);
    updatedPoints = [wrenchPose * [wv,ones(wrenchVertexCount,1)]']';  
    % Now update the Vertices
    wrenchMesh_h.Vertices = updatedPoints(:,1:3);
    drawnow();
    
end
    pause(0.1);

for i = 1:steps;
    guibool=gui.EStopButn;
    
    if guibool==1
        Resume = gui.ResumeButn;
        display('Estop Button Pressed - Release Estop and Resume')
             while Resume == 0
                 Resume = gui.ResumeButn;
                 pause(0.5)
                 guibool=gui.EStopButn;
                 if guibool == 0
                     display('EStop Released - Press Resume to Contuinue')
                     pause(1)
                 end
                 if Resume == 1
                     display('Resuming')
                 end
              guibool=gui.EStopButn;
             end
    end
     Qmatrix(i,:)= (1-s(i))*q2 + s(i)*q3;
     Kinova.model.animate(Qmatrix(i,:))
     
     qmove = Kinova.model.getpos();
     wrenchPose = Kinova.model.fkine(qmove);
     updatedPoints = [wrenchPose * [wv,ones(wrenchVertexCount,1)]']';  
     % Now update the Vertices
     wrenchMesh_h.Vertices = updatedPoints(:,1:3);
     drawnow();
    end
     pause(0.1);

%% Move robot & box wrench
p1 = bwrenchPose;
p2 = transl(0.3,0.5,2.2)*trotz(deg2rad(90));
p3 = transl(0.3,2.3,2.2)*trotz(deg2rad(90))*troty(deg2rad(-20));

q0 = Kinova.model.getpos();
q1 = Kinova.model.ikcon(p1);
q2 = Kinova.model.ikcon(p2);
q3 = Kinova.model.ikcon(p3);

steps = 30;
s = lspb(0,1,steps); 
qMatrix = nan(steps,6); 

for i = 1:steps; 
    guibool=gui.EStopButn;
    
    if guibool==1
        Resume = gui.ResumeButn;
        display('Estop Button Pressed - Release Estop and Resume')
             while Resume == 0
                 Resume = gui.ResumeButn;
                 pause(0.5)
                 guibool=gui.EStopButn;
                 if guibool == 0
                     display('EStop Released - Press Resume to Contuinue')
                     pause(1)
                 end
                 if Resume == 1
                     display('Resuming')
                 end
              guibool=gui.EStopButn;
             end
    end
        
    Qmatrix(i,:)= (1-s(i))*q0 + s(i)*q1;
    Kinova.model.animate(Qmatrix(i,:))
    
    end
    pause(0.1);

for i = 1:steps; 
    guibool=gui.EStopButn;
    
    if guibool==1
        Resume = gui.ResumeButn;
        display('Estop Button Pressed - Release Estop and Resume')
             while Resume == 0
                 Resume = gui.ResumeButn;
                 pause(0.5)
                 guibool=gui.EStopButn;
                 if guibool == 0
                     display('EStop Released - Press Resume to Contuinue')
                     pause(1)
                 end
                 if Resume == 1
                     display('Resuming')
                 end
              guibool=gui.EStopButn;
             end
    end
    Qmatrix(i,:)= (1-s(i))*q1 + s(i)*q2;
    Kinova.model.animate(Qmatrix(i,:))
    
    qmove = Kinova.model.getpos();
    bwrenchPose = Kinova.model.fkine(qmove);
    updatedPoints = [bwrenchPose * [bv,ones(bwrenchVertexCount,1)]']';
    % Now update the Vertices
    bwrenchMesh_h.Vertices = updatedPoints(:,1:3);
    drawnow();
    end
    
    pause(0.1);

for i = 1:steps;
    guibool=gui.EStopButn;
    
    if guibool==1
        Resume = gui.ResumeButn;
        display('Estop Button Pressed - Release Estop and Resume')
             while Resume == 0
                 Resume = gui.ResumeButn;
                 pause(0.5)
                 guibool=gui.EStopButn;
                 if guibool == 0
                     display('EStop Released - Press Resume to Contuinue')
                     pause(1)
                 end
                 if Resume == 1
                     display('Resuming')
                 end
              guibool=gui.EStopButn;
             end
    end
        
     Qmatrix(i,:)= (1-s(i))*q2 + s(i)*q3;
     Kinova.model.animate(Qmatrix(i,:))
     
     qmove = Kinova.model.getpos();
     bwrenchPose = Kinova.model.fkine(qmove);
     updatedPoints = [bwrenchPose * [bv,ones(bwrenchVertexCount,1)]']';  
     % Now update the Vertices
     bwrenchMesh_h.Vertices = updatedPoints(:,1:3);
     drawnow();
    end
    
     pause(0.1);

%% Move robot home
p1 = transl(0.2,0,1.2);

q0 = Kinova.model.getpos();
q1 = Kinova.model.ikcon(p1);
steps = 30;
s = lspb(0,1,steps); 
qMatrix = nan(steps,6); 

for i = 1:steps;
    guibool=gui.EStopButn;
    
    if guibool==1
        Resume = gui.ResumeButn;
        display('Estop Button Pressed - Release Estop and Resume')
             while Resume == 0
                 Resume = gui.ResumeButn;
                 pause(0.5)
                 guibool=gui.EStopButn;
                 if guibool == 0
                     display('EStop Released - Press Resume to Contuinue')
                     pause(1)
                 end
                 if Resume == 1
                     display('Resuming')
                 end
              guibool=gui.EStopButn;
             end
    end
    Qmatrix(i,:)= (1-s(i))*q0 + s(i)*q1;
    Kinova.model.animate(Qmatrix(i,:))
    end
    pause(0.1);
    
%%
function LoadBackground
image = imread('wallbackground.jpg');  
xImage = [-2 3.5; -2 3.5];  
yImage = [2 2; 2 2];     
zImage = [3 3; 0 0];  
surf(xImage,yImage,zImage,'CData',image,'FaceColor','texturemap');

image = imread('wallbackground.jpg');    
xImage = [-2 -2; -2 -2];  
yImage = [-2 2; -2 2];          
zImage = [3 3; 0 0];
surf(xImage,yImage,zImage,'CData',image,'FaceColor','texturemap');

surf([-2,-2;4,4],[-2,2;-2,2],[0,0;0,0],'CData',imread('concrete.jpg'),'FaceColor','texturemap');
end