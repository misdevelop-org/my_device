  <img src='https://firebasestorage.googleapis.com/v0/b/misdevelop.appspot.com/o/my_device%2FBCCF55AF-8340-4AFE-A381-6C473D1594A6.png?alt=media&token=da2abfa2-2909-4a3d-a39b-956659f04732' alt='My Device'>  
  
## Features    
    
Agile & easy handler for device information 📱    
    
## Getting started    
 Once context is initialized run     
 
```dart
 Device(context); 
 ```   

 ## Usage    
 #### Quick access to screen height and width    
 ```dart
 var screenHeigth = Device.i.screenHeigth; 
 var screenWidth = Device.i.screenWidth; 
 ```    
 #### Easy background asset path configuration    
 ```dart
  var backgroundAssetPath
  = Device.i.backgroundAssetPath;
   ```    
 #### Agile access to platform information and disposition    
 ```dart
  var webDevice = Device.i.isWeb; 
  var androidDevice = Device.i.isAndroid; 
  var iosDevice = Device.i.isIOS; 
  var isTablet = Device.i.isTablet;
   ```    
 #### Access to device default padding  
   
 ```dart
 var paddingDevice = Device.i.viewPadding;
  ```    
  
 #### Fast access to all device information    
 
 ```dart
  var device = Device.i.mediaQuery;
   ```    
   
 #### Fast access to all Device Information Plugin  
 
  ```dart
  var deviceInfo = Device.i.deviceInfo;
   ```    
   
 ## Additional information    
 This package assumes corresponding permissions depending on platform