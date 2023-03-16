import QtQml 2.3
// import BOMXStore 1.0 
import BOMXStore 1.0 as S

QtObject {
	
	Component.onCompleted: {
		runTest(testPropertyAccessor)
		runTest(testDefineProperty)
		runTest(testProxySupport)
		runTest(testSimplestClassDefunition)
		runTest(testBOMXStore)
		
		print('exit...')
		Qt.callLater(Qt.quit)
	}
	function runTest(f){
		function functionName(fun) {
			var ret = fun.toString();
			ret = ret.substr('function '.length);
			ret = ret.substr(0, ret.indexOf('('));
			return ret;
		}
		print('\n\n=== TEST ', functionName(f),     ' START ===')
		try{
			f()
			print('=== TEST ', functionName(f), '   OK  ===')
		}catch(e){
			print(e, e.stack)
			print('=== TEST ', functionName(f), '  FAIL ===')
		}
	}
	
	function testPropertyAccessor(){
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
	}
	function testDefineProperty(){
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
		print('John Smith=', user.fullName); // John Smith
		for(let key in user) 
			print(key); // name, surname
		print('backslash str interpretation supported too ')
	}
	function testProxySupport(){
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
	}
	function testSimplestClassDefunition(){
		class Rectangle {
		  // no fields supported here , only in constructor
		  constructor(height, width) {
			this.height = height;
			this.width = width;
		  }
		}
		print('new Rectangle(10,20).width=', new Rectangle(10,20).width)
		
		// experiment
		print('experiment class and instabce ')
		const sclass = class ABC {}
		const sclassInst = new sclass()
		sclass.ID = 'static f value'
		print('sclass=', sclass, 'sclass.ID=', sclass.ID, 'sclassInst=', sclassInst)
	}

	function testBOMXStore(){
		print('++++++++++++ MAIN TEST ++++++++++++')
		// capture for comfort coding 
		const store = S.Store.store
		const view = S.Store.view
		
		print('S.store=', S.Store.store, 'need function')
		print('S.view=', S.Store.store, 'need function')

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
		print('IT\'S WORKING !')
		
		// so need only now design ... virtual dom for qml OR state tree for clean components
	}
}

