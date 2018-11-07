<H1>WTF? (What The Film?)</H1>

<font>
This is an application for searching for movies, it has the ability to search for movies by name, by genre, you can also click on the date in the calendar and if some films are released on that day, they will be reflected at the bottom of the screen.
<p><font/>

<h4>It is also possible to search for movies on posters.<p></font>


<font>You get detailed information about the film:</font>

<h5>-Title</h5>
<h5>-Trailer</h5>
<h5>-Short description</h5>
<h5>-Release date</h5>
<h5>-Age limit</h5>
<h5>-Duration</h5>

<H2>Gif Demonstration Project</H2>

![](wtf.gif)

<H2>Installing</H2>

<font><a href="https://itunes.apple.com/us/app/xcode/id497799835?mt=12">1 First you need Xcode, you can download it from Apple Store.<p></a></font>
<font>2 After that, open the terminal and go with the cd command to the folder with the downloaded project.<p></font>
<font>3 Further it is necessary to install libraries (If they are not installed), for this:<p></font>
<h3><pre>3.1 Write the command: pod init ()
3.2 Write the command: open pod file 
3.3 Replace the contents of your file with:
# Uncomment the next line to define a global platform for your     project
# platform :ios, '9.0'

target 'FirstPagePosterApp' do
# Comment the next line if you're not using Swift and don't             
want to use dynamic frameworks

use_frameworks!

pod 'Firebase'
pod 'Firebase/Database'
pod 'Firebase/Core'

end
4.Command + s
5.Pod install 
6.After installing all files, open the file in the project folder. (FirstPagePosterApp.xcworkspace)

</pre></h3>
<h2>Built With</h2>
<font><a href = "https://developer.apple.com/documentation/uikit">UIKit</a> -  Construct and manage a graphical, event-driven user interface for your iOS.<p>
</font>
<font><a href = "https://firebase.google.com/docs/ios/setup?authuser=0">Firebase </a> -  Used to create a database.<p>
</font>
<font><a href = "https://developer.apple.com/documentation/arkit/recognizing_images_in_an_ar_experience">ARKit </a> -  Detect known 2D images in the userÅfs environment.
<p></font>
<H2>Authors</H2>
<font>Igor Terletskiy</font> 





