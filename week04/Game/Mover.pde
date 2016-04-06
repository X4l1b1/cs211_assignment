class Mover {

  PVector location;
  PVector velocity;
  PVector gravityForce;
  PVector projectedGravityForce;
  PVector friction;
  float gravityConstant = 1;
  float vBuffer;
  boolean edge;

  Mover() {
    location = new PVector(width/2, height/2 - 5 - 24, 0);
    velocity = new PVector(0, 0, 0);
    gravityForce = new PVector(0, 0, 0);
    projectedGravityForce = new PVector(0, 0, 0);
  }

  void update(float rotX, float rotZ) {
    pushMatrix();
    gravityForce.x = sin(rotZ) * gravityConstant;
    gravityForce.z = sin(rotX) * gravityConstant;
    projectedGravityForce = new PVector(gravityForce.x * cos(rotZ), (gravityForce.x * sin(rotZ)) + (gravityForce.z * sin(rotX)),gravityForce.z * cos(rotX));
    
    //gravityForce.y = sqrt((gravityForce.x * gravityForce.x) + (gravityForce.z * gravityForce.z)) * sin(abs(rotX - rotZ));
    
    //gravityForce.x = sin(rotZ) * cos(rotZ) * gravityConstant;
    //gravityForce.z = sin(rotX) * cos(rotZ) * gravityConstant;
    //gravityForce.y = sin(rotZ) * sin(rotZ) * gravityConstant + sin(rotX) * sin(rotX) * gravityConstant;
    edge = false;
    velocity.add(projectedGravityForce);
    
    float normalForce = 1;
    float mu = 0.01;
    float frictionMagnitude = normalForce * mu;
    friction = velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    velocity.add(friction);
    
    location.add(velocity);
    println("rotX = " + rotX + " rotZ = " + rotZ);
    println("Location " + location.x  + " " + location.y + " " + location.z);
    println("Velocity " + velocity.x + " " + velocity.y + " " + velocity.z);
    println("Gravity force " + gravityForce.x + " " + gravityForce.y + " " + gravityForce.z);
    println("Friction" + friction.x + " " + friction.y + " " + friction.z);
    println();
    popMatrix();
  }

  void display() {
    translate(location.x, location.y, location.z);
    sphere(24);
  }

  void checkEdges() { //<>//
    if(width/2 - location.x + 12 > 250 || width/2 - location.x - 12 < -250) {
     vBuffer     = -1 * velocity.x;
      velocity.x = 0;//-velocity.x; 
     velocity.y = -abs(velocity.y);
     edge = true;
    }
    if(velocity.x == 0 && edge){
     velocity.x = vBuffer; 
    }
    if(velocity.z == 0&& edge){
     velocity.z = vBuffer; 
    }
    if(location.z + 12 > 250 || location.z - 12 < -250) {
      vBuffer     = -1 * velocity.z;
     velocity.z = 0; 
     velocity.y = -abs(velocity.y);
    }
  }
}