
///////////////////////////////////////////INTERNAL HELP IMPORTANT LOGIC 
const reactionsMap = {};
// It will point to a component instance that is being rendered. 
// We are going to use it later on 🙂
let currentlyRenderingComponent;
// The handler currently does nothing so far...
const handler = {
  get: function(target, key) {
	// return target[key];  
	
	
	// If there is no component currently rendering it means that 
	// we have accessed the store from outside of a react component. 
	// We can just return the value for the given key
	if (typeof currentlyRenderingComponent === "undefined") {
	  return target[key];
	}
	// In case we don't track the `key` yet, start tracking it
	// and set its value to currently rendering component 
	if (!reactionsMap[key]) {
	  reactionsMap[key] = [currentlyRenderingComponent];
	}
	// We already track the `key`, so let's check 
	// if we track the currentlyRendering component for that key.
	const hasComponent = reactionsMap[key].find(
	  comp => comp.ID === currentlyRenderingComponent.ID
	);
	if (!hasComponent) {
	  reactionsMap[key].push(currentlyRenderingComponent);
	}
	return target[key];
  },
  set: function(target, key, value) {
	//target[key] = value;
	//return true;
	
	
	target[key] = value;
	reactionsMap[key].forEach(component => component.forceUpdate());
	return true;
  }
};

/////////////////////////////////////////////////////// STORE FUNCTION 
// For now, this just does nothing
function store(object) {
  return new Proxy(object, handler);
}

//print(Math.floor(Math.random() * 10e9))

/////////////////////////////////////////////////////// VIEW FUNCTION 
// And this also does not do anything yet...
// And this also does not do anything yet...
function view(MyComponent){
	print('view === 0')
	const sc = class Observer extends MyComponent { // extends MyComponent
		//constructor(){
			////this.ID = Math.floor(Math.random() * 10e9)
			//print('constructor, ID=', Observer.ID) // TODO uuid
		//}
		
		render() {
		  print('render called state.text=')
		  currentlyRenderingComponent = this;
		  const renderValue = super.render();
		  currentlyRenderingComponent = undefined;
		  return renderValue;
		}
	  };
	print('view === 1')
	sc.ID = Math.floor(Math.random() * 10e9)
	print('view === 2', sc.ID)
	return sc
}

