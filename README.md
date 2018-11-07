<H1>WTF? (What The Film?)</H1>

<h3>
This is an application for searching for movies, it has the ability to search for movies by name, by genre, you can also click on the date in the calendar and if some films are released on that day, they will be reflected at the bottom of the screen.
</h3>

<h3>It is also possible to search for movies on posters.<h3>

<h3>You get detailed information about the film:<h3>

<h4>-Title</h4>
<h4>-Trailer</h4>
<h4>-Short description</h4>
<h4>-Release date</h4>
<h4>-Age limit</h4>
<h4>-Duration</h4>

<H1>Gif Demonstration Project
</H1>

<img width="240" height="480" border="1" src="https://firebasestorage.googleapis.com/v0/b/videostreaming-f70b0.appspot.com/o/fn.gif?alt=media&token=3328efc7-add0-4142-a63e-5c424ee13def"></img>

<H1>Getting Started</H1>
<H2>Installing</H2>

<h3><a href="https://itunes.apple.com/us/app/xcode/id497799835?mt=12">1 First you need Xcode, you can download it from Apple Store.</a></h3>
<h3>2 After that, open the terminal and go with the cd command to the folder with the downloaded project.</h3>
<h3>3 Further it is necessary to install libraries (If they are not installed), for this:
</h3>
<h3><pre>3.1 Write the command pod init (If it is not already)

3.2 Write the command open pod file ?
3.3 Replace the contents of your file with:
	# Uncomment the next line to define a global platform for your 	project
	# platform :ios, '9.0'

	target 'FirstPagePosterApp' do
  	# Comment the next line if you're not using Swift and don't 			
      want to use dynamic frameworks
  
	use_frameworks!

  	pod 'Firebase'
 	pod 'Firebase/Database'
 	pod 'Firebase/Core'

	end

4. Pod install after installing all files, open the file in the project folder. (FirstPagePosterApp.xcworkspace)

</pre></h3>
<h1>Built With</h1>
<h3><a href = "https://developer.apple.com/documentation/uikit">UIKit</a> -  Construct and manage a graphical, event-driven user interface for your iOS.
</h3>
<h3><a href = "https://firebase.google.com/docs/ios/setup?authuser=0">Firebase </a> -  Used to create a database.
</h3>
<h3><a href = "https://developer.apple.com/documentation/arkit/recognizing_images_in_an_ar_experience">ARKit </a> -  Detect known 2D images in the userÅfs environment.
</h3>
<H1>Authors</H1>
<H2>Igor Terletskiy</H2> 




