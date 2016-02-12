//
//  DJIRootViewController.h
//

#import <UIKit/UIKit.h>
#import <DJISDK/DJISDK.h>
#import "DJIMapController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DJIRootViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate, DJIDroneDelegate, DJIMainControllerDelegate, GroundStationDelegate, DJINavigationDelegate, DJIAppManagerDelegate, DJICameraDelegate>

//mapping
@property (nonatomic, strong) DJIMapController *mapController;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, strong) CLLocationManager* locationManager;
@property(nonatomic, assign) CLLocationCoordinate2D userLocation;
@property(nonatomic, assign) CLLocationCoordinate2D droneLocation;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) MKMapCamera *mapCamera;

//status bar
@property (weak, nonatomic) IBOutlet UINavigationBar *topBarView;

//status bar labels
@property(nonatomic, strong) UIColor *myColorBlue;
@property(nonatomic, strong) UIColor *myColorGreen;
@property(nonatomic, strong) IBOutlet UILabel* modeLabel;
@property(nonatomic, strong) IBOutlet UILabel* gpsLabel;
@property(nonatomic, strong) IBOutlet UILabel* hsLabel;
@property(nonatomic, strong) IBOutlet UILabel* vsLabel;
@property(nonatomic, strong) IBOutlet UILabel* altitudeLabel;

//Before Launch state variable checks
@property(atomic) int gpsSatelliteCount;
@property(atomic) int powerLevel;
@property(atomic) DJIGpsSignalLevel gpsSignalLevel;
@property (atomic) float missionLengthDistance;
@property (atomic) float missionLifeTime;
@property (atomic) float advertisedFlightTime;
@property (atomic) float remainingFlightTime;
@property (atomic) float powerScaleFactor;
@property(nonatomic, strong) DJIBattery *batteryInfo;
@property (atomic) long powerPercent;

//Drone and flight controller
@property(nonatomic, strong) DJIDrone* phantomDrone;
@property(nonatomic, strong) DJIPhantom3ProMainController* phantomProMainController;

//Camera
@property(nonatomic, strong) DJIPhantom3ProCamera *camera;

//waypoints and navigation
@property(nonatomic, weak) NSObject<DJINavigation>* navigationManager;
@property(nonatomic, weak) NSObject<DJIWaypointMission>* waypointMission;

//upload mission progress
@property(nonatomic, strong) UIAlertView* uploadProgressView;

//Battery graphic information
@property (nonatomic, strong) IBOutlet UILabel *batteryPercentage;
@property (weak, nonatomic) IBOutlet UIView *batterySymbol;
@property (weak, nonatomic) IBOutlet UIImageView *batteryBorder;

@end
