import QtQml 2.3
//import "mobx.umd.production.min.js" as JS

QtObject {
	Component.onCompleted: {
		/*for (key in JS){
			console.log( key + ": " + JS[key]);
			quit()
		}*/
		print(Object.defineProperty)
		

// https://javascript.info/property-accessors	
// property-accessors OK
let obj = {
	get propName() {
		// getter, the code executed on getting obj.propName
	},

	set propName(value) {
		// setter, the code executed on setting obj.propName = value
	}
};
print(obj)
		
		
let user0 = {
  name: "John",
  surname: "Smith",


  get fullName() {
    return '' + this.name + ' ' + this.surname
  }
};
print(user0.fullName); // John Smith		



var user = {
  name: "John",
  surname: "Smith"
};
Object.defineProperty(user, 'fullName', {
  get() {
	  print('backslash str interpretation:')
    return `${this.name} ${this.surname}`; // OK supported
  },

  set(value) {
    [this.name, this.surname] = value.split(" ");
  }
});
print(user.fullName); // John Smith
for(let key in user) print(key); // name, surname







// https://czaplinski.io/blog/make-your-own-mobx/#proxies
// Proxy  OK
print('Proxy=', Proxy)
const target = {
  number: 42,
};
const handler = {};
const proxy = new Proxy(target, handler);
print(proxy.number);  // 42
print(JSON.stringify(proxy) === JSON.stringify(target))  // true





class Rectangle {
  // no fields supported here , only in constructor
  constructor(height, width) {
    this.height = height;
    this.width = width;
  }
}
print('new Rectangle(10,20).width=', new Rectangle(10,20).width)





// https://czaplinski.io/blog/make-your-own-mobx/
// MAKE OWN MOBX
{
	// class MyComponent {} class supported but no filed syntax
	
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
	// For now, this just does nothing
	function store(object) {
	  return new Proxy(object, handler);
	}

	//print(Math.floor(Math.random() * 10e9))
	
	// And this also does not do anything yet...
	// And this also does not do anything yet...
	function view(MyComponent) {
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
	// experiment
	const sclass = class ABC {}
	const sclassInst = new sclass()
	sclass.ID = 'static f value'
	print('sclass=', sclass, 'sclass.ID=', sclass.ID, 'sclassInst=', sclassInst)


	/// using 
	const state = store({
		text: "oldtextvalue",
		number: 0,
		increment: () => state.number++,
		decrement: () => state.number--
	});
	print('state=', state)
	let iTest = null
	const AppWrapedClass = view(
		class App  { // extends Component
			render() {
				const val = 'aaa '+ state.text + '   bbb'
				const i = state.increment
				iTest = i
				const d = state.decrement
				return  val 
				//(
				//<>
				  //<button onClick={() => state.increment()}> +1 </button>
				  //<button onClick={() => state.decrement()}> -1 </button>

				  //<input
					//placeholder="type something"
					//onChange={e => (state.text = e.target.value)}
					//value={state.text}
				  ///>
				  //<pre>{JSON.stringify(state, null, 2)}</pre>
				//</>
				//);
			}
			
			forceUpdate(){
				print('forceUpdate IN class App')
				print(this.render())
			}			
		}
	);
	
	//ReactDOM.render(<App />, document.getElementById("root"));
	print('AppWrapedClass class =', AppWrapedClass)
	const appIst = new AppWrapedClass()
	print('appIst=', appIst, 'appIst.render=', appIst.render, 'appIst.render()=', appIst.render())
	print('lets set state.text...:')
	state.text = 'newnewnew'

}



	}
}
