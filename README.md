# DSL Transpiler

To generate java file, use :
`gradle generateJavaFile`

# AiC DSL

Example : *test_file_example.aic*

    Feature: "Example feature"
    
        Scenario: "Example scenario 1"
            Take a screenshot
        End
        
        Scenario: "Example scenario 2"
            Set sensor LIGHT_SENSOR at 42
            Set battery level at 5
        End
        
    End


### Features
You can only write one feature per file. Set name with double quote. Finished with keyword ```End```

### Scenarios
You could write as many scenario as you want into a feature. Like features, set name with double quote and finished with keyword ```End```. It contains DSL instructions.

### Instructions
* Set sensor *SENSOR_TYPE* at *SENSOR_VALUE(Integer)* 
* Set battery level at *BATTERY_LEVEL(Integer)*
* Set Gps position at *LATITUDE_VALUE(Float)*, *LONGITUDE_VALUE(Float)*, *ALTITUDE_VALUE(Float)*
* Take a screenshot
* Start recording
* Stop recording

### Sensor Type

* TYPE_ACCELEROMETER
* TYPE_LINEAR_ACCELERATION
* TYPE_PRESSURE
* TYPE_LIGHT
* TYPE_TEMPERATURE
* TYPE_AMBIENT_TEMPERATURE
* TYPE_PROXIMITY
* TYPE_GRAVITY
* TYPE_MAGNETIC_FIELD
* TYPE_GYROSCOPE
* TYPE_ROTATION_VECTOR

### Recording
You have the abilitie to record your test set, by taking screenshot and/or taking video from the virtual machine screen.

### Write test with UiAutomator
You have to include AiC Test Framework into your Android project.
Then create new testing source file in your project.
You can write "classic" UiAutomator tests, and/or include AiC special instructions like setting sensors or location.

Example :

    import .....;
    
    import com.zenika.aic.core.libs.sensor.Device;
    
    @RunWith(AndroidJUnit4.class)
    public class Testing extends InstrumentationTestCase {
    
    	private Device device;
    	private String appName = "Sensor";
    
    
        @Before
        public void init() {
            device = new Device(appName, InstrumentationRegistry.getInstrumentation());
    	}
    
    	@Test
    	public void test_one() {
    		device.getBatteryInstance().setLevel(100, 100);
    		device.takeScreenshot();
    		device.startRecording();
    		device.waitForUpdate();
    	}
    
    	@Test
    	public void test_two() {
    		device.getBatteryInstance().setLevel(25, 100);
    		try {
    			selectSensor("Photometer", "Sensor");
    		} catch (UiObjectNotFoundException e) {
    			e.printStackTrace();
    		} catch (RemoteException e) {
    			e.printStackTrace();
    		}
    		device.waitForUpdate();
    		device.takeScreenshot();
    		device.setValuesForSensor(new float[]{42}, Sensor.TYPE_LIGHT);
    		device.waitForUpdate();
    		device.takeScreenshot();
    		try {
    			selectSensor("Home", "Photometer");
    		} catch (UiObjectNotFoundException e) {
    			e.printStackTrace();
    		} catch (RemoteException e) {
    			e.printStackTrace();
    		}
    		device.waitForUpdate();
    		device.stopRecording();
    	}
    	
        public void selectSensor(String sensor, String from) throws UiObjectNotFoundException, RemoteException {
    		UiObject2 navigationDrawerButton = device.getUiDevice().findObject(By.text(from));
    		assertTrue("Navigation drawer button not found", navigationDrawerButton != null);
    		navigationDrawerButton.click();
    
    		device.getUiDevice().waitForWindowUpdate("", 1000);
    
    		UiObject2 item = device.getUiDevice().findObject(By.text(sensor));
    		assertTrue(sensor + " item not found", navigationDrawerButton != null);
    		item.click();
    	}
    }
