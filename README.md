# SwiftUI-Tutorials

https://developer.apple.com/tutorials/swiftui

### Overview

 + 1 Creating and Combining Views
 + 2 Building Lists and Navigation
 + 3 Handling User Input
 + 4 Drawing Paths and Shapes
 + 5 Animating Views and Transitions
 + 6 Composing Complex Interfaces
 + 7 Working with UI Controls
 + 8 Interfacing with UIKit

### Screenshot

| ![1](https://raw.githubusercontent.com/liangtongdev/SwiftUI-Tutorials/master/screenshot/01.png) | ![2](https://raw.githubusercontent.com/liangtongdev/SwiftUI-Tutorials/master/screenshot/02.png) | ![3](https://raw.githubusercontent.com/liangtongdev/SwiftUI-Tutorials/master/screenshot/03.png) |
|  ----  | ----  |  ----  |
| ![4](https://raw.githubusercontent.com/liangtongdev/SwiftUI-Tutorials/master/screenshot/04.png) | ![5](https://raw.githubusercontent.com/liangtongdev/SwiftUI-Tutorials/master/screenshot/05.png) | ![6](https://raw.githubusercontent.com/liangtongdev/SwiftUI-Tutorials/master/screenshot/06.png) |
| ![7](https://raw.githubusercontent.com/liangtongdev/SwiftUI-Tutorials/master/screenshot/07.png) | ![8](https://raw.githubusercontent.com/liangtongdev/SwiftUI-Tutorials/master/screenshot/08.png) | ![9](https://raw.githubusercontent.com/liangtongdev/SwiftUI-Tutorials/master/screenshot/09.png) |
| ![10](https://raw.githubusercontent.com/liangtongdev/SwiftUI-Tutorials/master/screenshot/10.png) | ![11](https://raw.githubusercontent.com/liangtongdev/SwiftUI-Tutorials/master/screenshot/11.png) | ![12](https://raw.githubusercontent.com/liangtongdev/SwiftUI-Tutorials/master/screenshot/12.png) |

### 知识梳理



#### SwiftUI App 启动

+ AppDelegate UISceneSession Lifecycle
+ UISceneConfiguration Default Configuration
+ Info.plist： UIApplicationSceneManifest -> UISceneConfigurations -> SceneDelegate
+ scene: willConnectToSession: options: (iOS 启动流程)
+ UIHostingController:UIViewController (接受一个 SwiftUI 的 View 描述并将其用 UIKit 进行渲染)


#### SwiftUI页面结构

+ 遵从View协议
```SwiftUI
public protocol View : _View {
    associatedtype Body : View
    var body: Self.Body { get }
}
```
这种带有 `associatedtype` 的协议不能作为类型来使用，而只能作为类型约束使用：
```SwiftUI
struct ContentView: View {
    var body: some View {
        Text("Turtle Rock")
    }
}
```
`some View` 这种写法使用了 Swift 5.1 的 Opaque return types 特性。它向编译器作出保证，每次 body 得到的一定是某一个确定的，遵守 View 协议的类型。

+ 预览渲染

```SwiftUI
struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

#### 链式调用
```SwiftUI
var body: some View {
    Image("turtlerock")
        .clipShape(Circle())
        .overlay(
            Circle().stroke(Color.white, lineWidth: 4))
        .shadow(radius: 10)
}
```

#### ViewBuilder

 `HStack`、`VStack`、`ZStack`，这里拿`HStack`进行说明。结构体构造器定义如下

 ```SwiftUI
 public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> Content)
 ```

包含3个参数，对其方式和spacing没啥说的。最后一个是被`@ViewBuilder`标记的闭包，作用是将闭包内的 Text 或其他 View 转换为一个 TupleView返回。

使用例子：
```SwiftUI
HStack(alignment: .top) {
                    Text(landmark.park)
                        .font(.subheadline)
                    Spacer()
                    Text(landmark.state)
                        .font(.subheadline)
                }
```


#### List

```SwiftUI
var body: some View {
    List {
        LandmarkRow(landmark: landmarkData[0])
        LandmarkRow(landmark: landmarkData[1])
    }
}
```
对于`List`来说，SwiftUI底层使用`UITableView`来进行绘制

#### 属性修饰器

##### @State

通过使用 @State 修饰器我们可以关联出 View 的状态， 当 @State 装饰过的属性发生了变化，SwiftUI 会根据新的属性值重新创建视图
```SwiftUI
    @State var showingProfile = false

    var profileButton: some View {
        Button(action: { self.showingProfile.toggle() }) {
            Image(systemName: "person.crop.circle")
                .imageScale(.large)
                .accessibility(label: Text("User Profile"))
                .padding()
        }
    }

    var body: some View {
        NavigationView {
        	// ...
            .navigationBarTitle(Text("Featured"))
            .navigationBarItems(trailing: profileButton)
            .sheet(isPresented: $showingProfile) {
                Text("User Profile")
            }
        }
    }
```

##### @Binding

 Swift 中值的传递形式是值类型传递方式，通过 @Binding 修饰器修饰后，属性变成了一个引用类型，传递变成了引用传递。通常在视图属性传递时使用，例如PageViewController 和 PageControl之间 currentPage 属性的传递。


##### @Published

```SwiftUI
final class UserData: ObservableObject{
    @Published var showFavoritesOnly = false
    @Published var landmarks = landmarkData
}
```
对象遵从`ObservableObject`协议, 对于 Published 修饰的属性， 一旦发生了变换，SwiftUI 会更新相关联的 UI


##### @EnvironmentObject

```SwiftUI
    @EnvironmentObject var userData: UserData

    XXXX()
    .environmentObject(UserData())
```
这个修饰器是针对全局环境的。通过它，我们可以避免在初始 View 时创建 ObservableObject, 而是从环境中获取 ObservableObject

##### @Environment

系统级别的设定，我们开一个通过 @Environment 来获取到它们

```SwiftUI
    @Environment(\.editMode) var mode
    
    @Environment(\.calendar) var calendar: Calendar
    @Environment(\.locale) var locale: Locale
    @Environment(\.colorScheme) var colorScheme: ColorScheme
```

#### 动画

+ 直接在view上使用`.animation()`来修改
+ 使用`withAnimation{}`来控制某个状态，触发动画

```SwiftUI
	Button(action: {
        self.showDetail.toggle() 
    }) {
        Image(systemName: "chevron.right.circle")
            .imageScale(.large)
            .rotationEffect(.degrees(showDetail ? 90 : 0))
        	.animation(nil)	//去除动画
            .scaleEffect(showDetail ? 1.5 : 1)
            .padding()
        	.animation(.spring())
    }
```
SwiftUI 的 modifier 是有顺序的。在我们调用 animation(_:) 时，SwiftUI 做的事情等效于是把之前的所有 modifier 检查一遍，然后找出所有满足 Animatable 协议的 view 上的数值变化，比如角度、位置、尺寸等，然后将这些变化打个包，创建一个事物 (Transaction) 并提交给底层渲染去做动画。



```SwiftUI
	Button(action: {
        withAnimation {
            	self.showDetail.toggle()
        }
    }) {
        Image(systemName: "chevron.right.circle")
            .imageScale(.large)
            .rotationEffect(.degrees(showDetail ? 90 : 0))
            .scaleEffect(showDetail ? 1.5 : 1)
            .padding()
    }
```

withAnimation 是统一控制单个的 Transaction，而针对不同 View 的 animation(_:) 调用则可能对应多个不同的 Transaction。



#### View的生命周期

```SwiftUI
		ProfileEditor(profile: $draftProfile)       
        .onAppear {
            self.draftProfile = self.userData.profile
        }
        .onDisappear {
            self.userData.profile = self.draftProfile
        }
```


#### NavigationView

```SwiftUI
struct LandmarkList: View {
    var body: some View {
        NavigationView {
            List(landmarkData) { landmark in
                NavigationLink(destination: LandmarkDetail(landmark: landmark)) {
                    LandmarkRow(landmark: landmark)
                }
            }
            .navigationBarTitle(Text("Landmarks"))
        }
    }
}
```

+ NavigationView ，页面跳转
+ NavigationLink(destination:) , 跳转页面


#### UIKit 接口

##### UIView

+ 遵从 `UIViewRepresentable` 协议，重写 `makeUIView(context:)` 和 `updateUIView(_:context:)`方法

##### UIViewController

+ 遵从 `UIViewControllerRepresentable` 协议，重写 `makeUIViewController(context:)` 和 `updateUIViewController(_:context:)`方法


##### Coordinator

UIView或UIViewController会有自己的dataSource 或 delegate，通常的做法是在结构体内部定义Coordinator类，由Coordinator类来实现这些特点协议（或提供特点的方法）。然后在makeUIViewxxx的内部设置对应的delegate。例如：

```SwiftUI
struct PageControl: UIViewRepresentable {
    var numberOfPages: Int
    @Binding var currentPage: Int

    func makeCoordinator() -> Coordinator {
       return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.pageIndicatorTintColor = .gray;
        control.currentPageIndicatorTintColor = .white;

        control.addTarget(
        context.coordinator,
        action: #selector(Coordinator.updateCurrentPage(sender:)),
        for: .valueChanged)
        return control
    }

    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }
    
    class Coordinator: NSObject {
        var control: PageControl
        init(_ control: PageControl) {
            self.control = control
        }
        @objc func updateCurrentPage(sender: UIPageControl) {
            control.currentPage = sender.currentPage
        }
    }
}
```

```SwiftUI
struct PageViewController: UIViewControllerRepresentable {
    
    var controllers: [UIViewController]
    @Binding var currentPage: Int
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        return pageViewController
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers(
            [controllers[currentPage]], direction: .forward, animated: true)
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource,UIPageViewControllerDelegate {
        //...
    }
}
```
