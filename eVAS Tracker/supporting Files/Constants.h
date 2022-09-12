//
//  Constants.h
//  RegCard
//
//  Created by Samsotech on 10/14/15.
//  Copyright © 2015 Samsotech. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "DebugSettings.h"
#import "STDateFormats.h"
#import "StoryboardIdentifiers.h"
//#import "STRPdfFieldNameDefaultKeys.h"
//#import "STInfoSyncStatus.h"

// brian
// TODO: uniform naming convention

//main tag key
#define key_passKeyVal          @"passkeyVal"
#define key_tokenVal            @"token"
#define key_uniqueIdentifier    @"uIdentifer"
#define key_fileName            @"file_name"
#define key_confno              @"ConfirmationNo"
#define key_fileContent         @"fileContent"
#define key_scannedImages       @"scannedImages"
#define key_deviceName          @"device_name"
#define key_xmlStringValue      @"xmlValue"
#define key_signatureImage      @"signImage"
#define key_signatureFileName   @"signImage_Name"
#define key_GuestDocumentID     @"GuestDocumentID"

#define val_passKeyVal          @"samsotech"

/*********************************
 Comments From: Praveen PK, Samsotech LLC
 Methode Name :
 Parameters   :
 Details      : details for DRegCard
 *********************************/
#define key_RecordID            @"record_id"
#define key_GuestNAme           @"guestName"
#define key_RoomNumber          @"roomNumber"
#define key_ArrivalDate         @"arrivalDate"
#define key_DepartureDate       @"departureDate"
#define key_GuestCount          @"guestCount"
#define key_ReservationNumber   @"reservationNumber"
#define key_ImageName           @"imageName"
#define key_ImageData           @"image"
#define key_EmailValue          @"emailid"
#define key_MobileValue         @"mobilenumber"
#define key_AddressValue        @"address"
#define key_CityValue           @"city"
#define key_CountryValue        @"country"

#define key_SharerImageToService     @"shareSignImage"
#define key_SharerImageNameToService @"shareSignImage_Name"

#define PostName_sendPDF                    @"sendPDFtoServer_ERC"
#define PostName_FileReceived               @"FileReceived_ERC"
#define PostName_PushReceived               @"pushreceivedERC"
#define PostName_PushReceived4RegCard       @"pushreceivedERC4regcard"
#define PostName_PushReceivedToExitDocument @"puchReceivedtoCloseDocView"
#define PostName_RefreshDocument            @"RefreshDocument"

#define url_GetStatus_suffix                @"/getstatus"
#define url_RegisterDevice_suffix           @"/registerDevice"
#define url_RecivePDFfromServer_suffix      @"/ReceiveRegCard"
#define url_SendPDFtoServer_suffix          @"/SendRegCard"
#define url_SendPDFCheckbox_suffix          @"/SendRegCardCheckBox"
#define url_ReceiveRegCardData_suffix       @"/ReceiveRegCardData"
#define url_SendRegCardData_suffix          @"/SendRegCardData"
#define url_ReceiveRegCardDataV2_suffix     @"/ReceiveRegCardDataV2"
#define url_SendRegCardDataV2_suffix        @"/SendRegCardDataV2"
#define url_GetPresentationImages_suffix    @"/GetPresentationImages"
#define url_GetPromotionImages_suffix       @"/GetPromotionImages"
#define url_CreateXML_suffix                @"/CreateXml"
#define url_GetOfflineDocuments_Suffix      @"/getOfflineDocuments"
#define url_SendBackOfflineDocument_Suffix  @"/SendOfflineDocuments"
#define url_CheckDoumentStatus_Suffix       @"/CheckDoumentStatus"
#define url_DeleteDoc_Suffix                @"/DeleteRegcard"
#define url_FetchCountryStates_Suffix       @"/owsrequest?FunctionName=GetStateListByCountry"
#define url_FetchCountryCodes_Suffix       @"/owsrequest?FunctionName=GetCountryCodes"

#define url_kiosk_GetStateListByCountry     @"GetStateListByCountry"
#define url_kiosk_GetCountryCodes           @"GetCountryCodes"
#define url_kiosk_UpdateProfileUDF          @"UpdateProfileUDFWithProfileID"

#define str_Defaults_serviceURL                @"eRegCard_ServiceURL"
#define str_Defaults_kioskURL                  @"KioskServiceURL"
#define str_Defaults_owsURL                    @"OwsServiceURL"
#define str_Defaults_serviceMode               @"serviceModeofTransfer"
#define str_Defaults_deviceToken               @"deviceToke_ERC"
#define str_Defaults_ValidityFor7Days          @"checkforvalidity"
#define str_Defaults_DateFormat                @"dateformateVal"
#define str_Defaults_FolioSignature            @"folioSignatureRequired"
#define str_Defaults_FeedbackRequired          @"feedbackRequiredBeforeSigning"
#define str_Defaults_HandWrittenFieldsVisible  @"emailandmobilenumberButtonVisible"
#define str_Defaults_PreferredLanguage         @"languageselectionforfeedback"
#define str_Defaults_FeedbackAutocompletion    @"autocompletionOfFeedback"
#define str_Defaults_TimerValueForPresentation @"timerValueForPrsesc"
#define str_Defaults_SettingsUsername          @"eregSettingsUsername"
#define str_Defaults_SettingsPassword          @"eregSettingsPassword"
#define str_Defaults_OTPSetting                @"OTPSettingsForeRegVICAS"
#define str_Defaults_OfflineModeState          @"ApplicationGoOffline"
#define str_Defaults_OperaSyncMode             @"OperaSyncMode"
#define str_Defaults_PresentationActive        @"PresentationActive"
#define str_Defaults_PromotionActive           @"PromotionActive"
#define str_Defaults_FullscreenSlides          @"FullscreenSlides"
#define str_Defaults_SlideImageFit             @"SlideImageFit"

// TODO: rename related to V2 Folio upload
#define UserDefaults_AlertInvoiceEmail         @"AlertInvoiceEmail"
#define UserDefaults_AlertUpdateEmail          @"AlertUpdateEmail"
#define UserDefaults_AlertCallTaxi             @"AlertCallTaxi"
#define UserDefaults_AlertHotelRating          @"AlertHotelRating"
#define UserDefaults_AlertFolioSendData        @"AlertFolioSendData"

#define User_Defaults_ReservationData          @"ReservationData"
#define UserDefaults_EnableAppLog              @"EnableAppLog"
#define UserDefaults_EnableCompanyWebsite      @"EnableCompanyWebsite"
#define UserDefaults_CompanyWebsite            @"CompanyWebsite"
#define UserDefaults_CompanyTerms              @"CompanyTerms"
#define UserDefaults_CompanyPrivacy            @"CompanyPrivacy"

#define UserDefaults_BirthPlaceUDF             @"BirthPlaceUDF"
#define UserDefaults_OccupationUDF             @"OccupationUDF"

#define str_PresentationFoldername          @"PresentationImages"
#define str_PromotionFoldername             @"PromotionImages"

#define str_RedColorValueForPDF             @"redcolorvalueforsaving"
#define str_GreenColorValueForPDF           @"greencolorvalueforsaving"
#define str_BlueColorValueForPDF            @"bluecolorvalueforsaving"
#define str_AlphaColorValueForPDF           @"alphacolorvalueforsaving"

#define str_RedColorValueForPDF_TEXT             @"redcolorvalueforsaving_TEXT"
#define str_GreenColorValueForPDF_TEXT           @"greencolorvalueforsaving_TEXT"
#define str_BlueColorValueForPDF_TEXT            @"bluecolorvalueforsaving_TEXT"

#define str_BoldTextEnabled    @"BoldPdfFormFieldsEnabled"
#define str_PdfFormFontFamily  @"PdfFormFontFamily"
#define str_PdfFormFontSize    @"PdfFormFontSize"

//CRREG0006
#define str_2ndSignatureForRegistrationCard @"Const_SecondSignForRegCard"
#define str_2ndSignatureForFolioCard        @"Const_SecondSignForFolio"
#define str_BlinkSignatureButton            @"Const_EnableBlinkForSignButton"
#define str_RequireCompanyLogo              @"Const_EnableComapnyLogo"
#define str_DefaultsV1V2ModeSelection       @"ifV2ModeisSelectedOrNot"

//-- added by Brian
#define str_MandatoryFieldsDictionary   @"mandatoryfieldsdictionary"
#define str_SettingsRequirementFlags    @"settingsrequirementflags"
#define str_UpsellPrimarySignatureTitle @"upsellprimarysignaturetitle"
#define str_UpsellAgentSignatureTitle   @"upsellagentsignaturetitle"
//--

#define str_FolderName_Resource             @"SAMSO_Resources"
#define str_SecondSignatureText             @"titleForSecondSignature"

@interface Constants : NSObject

extern NSUInteger const STMaximumProfilePerSync;
extern NSUInteger const STRequestTimeOut;
extern NSString*  const STEncryptionKey;
extern NSString*  const STSignFlowLogTag;

extern NSString* const STDefaultsKeyKioskUserName;
extern NSString* const STDefaultsKeyKioskPassword;
extern NSString* const STDefaultsKeyHotelCode;
extern NSString* const STDefaultsKeyLanguage;
extern NSString* const STDefaultsKeyKioskID;
extern NSString* const STDefaultsKeySystemType;
extern NSString* const STDefaultsKeyLegNumber;
extern NSString* const STDefaultsKeyChainCode;
extern NSString* const STDefaultsKeyLogMaxDays;

extern NSString* const STDefaultsKeyProfileCountForResvNo;
extern NSString* const STDefaultsKeyProfileCreated;
extern NSString* const STPrefsKeySignedDoc;

// ==
extern NSString* const STErrorServerTimeout;

@end
