//
//  DJIRootViewController.h
//

#import <UIKit/UIKit.h>
#import <DJISDK/DJISDK.h>
#import "DJIMapController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DJIRootViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate, DJIDroneDelegate, DJIMainControllerDelegate, GroundStationDelegate, DJINavigationDelegate, DJIAppManagerDelegate>

@property (nonatomic, strong) DJIMapController *mapController;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, strong) CLLocationManager* locationManager;
@property(nonatomic, assign) CLLocationCoordinate2D userLocation;
@property(nonatomic, assign) CLLocationCoordinate2D droneLocation;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) MKMapCamera *mapCamera;

@property (weak, nonatomic) IBOutlet UINavigationBar *topBarView;

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
@property(nonatomic, strong) DJIBattery *batteryInfo;

@property(nonatomic, strong) DJIDrone* phantomDrone;
@property(nonatomic, strong) DJIPhantom3ProMainController* phantomProMainController;

@property(nonatomic, weak) NSObject<DJINavigation>* navigationManager;
@property(nonatomic, weak) NSObject<DJIWaypointMission>* waypointMission;

@property(nonatomic, strong) UIAlertView* uploadProgressView;

//Battery graphic information
@property (nonatomic, strong) IBOutlet UILabel *batteryPercentage;
@property (weak, nonatomic) IBOutlet UIView *batterySymbol;
@property (weak, nonatomic) IBOutlet UIImageView *batteryBorder;

@end
