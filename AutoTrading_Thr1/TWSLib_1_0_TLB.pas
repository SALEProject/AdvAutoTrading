Unit TWSLib_1_0_TLB;

//  Imported TWSLib on 9/22/2014 2:59:29 from Tws.ocx

{$mode delphi}{$H+}

interface

Uses
  Windows,ActiveX,Classes,Variants,EventSink;
Const
  TWSLibMajorVersion = 1;
  TWSLibMinorVersion = 0;
  TWSLibLCID = 0;
  LIBID_TWSLib : TGUID = '{0A77CCF5-052C-11D6-B0EC-00B0D074179C}';

  IID_IComboLeg : TGUID = '{573E95CF-F67C-4367-A95B-CB7599BD0673}';
  IID_IComboLegList : TGUID = '{BE3E5CD3-6F13-4D39-981C-4F75C063C2BA}';
  IID_IUnderComp : TGUID = '{E5EE73C4-7D45-428E-A347-821CBF918AA6}';
  IID_IContract : TGUID = '{AE6A66F3-8FA9-4076-9C1F-3728B10A4CC7}';
  IID_IContractDetails : TGUID = '{64F03988-ED93-452E-830B-3420DF21BAF9}';
  IID_ITagValue : TGUID = '{06FF1D3F-F12F-47D1-9443-A74D3CD58723}';
  IID_ITagValueList : TGUID = '{CC48E64E-C1A7-4867-8738-578404D75088}';
  IID_IOrder : TGUID = '{25D97F3D-2C4D-4080-9250-D2FB8071BE58}';
  IID_IOrderState : TGUID = '{7B33AE1F-99B0-4BCB-A024-42335897A6AF}';
  IID_IExecution : TGUID = '{58BDEC36-791C-4E2E-88A4-6E4339392B5B}';
  IID_IExecutionFilter : TGUID = '{3553EA07-F281-433D-B2A4-4CB722A9859B}';
  IID_IScannerSubscription : TGUID = '{6BBE7E50-795D-4C45-A69E-E1EEB7918DD2}';
  IID_IOrderComboLeg : TGUID = '{639C4479-D0B6-49A3-B524-AEA6A9574945}';
  IID_IOrderComboLegList : TGUID = '{39F18DDF-687D-421D-8BB9-4F389D69E428}';
  IID_ICommissionReport : TGUID = '{51AE469F-D859-4537-A0BA-A93992F395BB}';
  IID__DTws : TGUID = '{0A77CCF6-052C-11D6-B0EC-00B0D074179C}';
  IID__DTwsEvents : TGUID = '{0A77CCF7-052C-11D6-B0EC-00B0D074179C}';
  CLASS_Tws : TGUID = '{0A77CCF8-052C-11D6-B0EC-00B0D074179C}';

//Enums

//Forward declarations

Type
 IComboLeg = interface;
 IComboLegDisp = dispinterface;
 IComboLegList = interface;
 IComboLegListDisp = dispinterface;
 IUnderComp = interface;
 IUnderCompDisp = dispinterface;
 IContract = interface;
 IContractDisp = dispinterface;
 IContractDetails = interface;
 IContractDetailsDisp = dispinterface;
 ITagValue = interface;
 ITagValueDisp = dispinterface;
 ITagValueList = interface;
 ITagValueListDisp = dispinterface;
 IOrder = interface;
 IOrderDisp = dispinterface;
 IOrderState = interface;
 IOrderStateDisp = dispinterface;
 IExecution = interface;
 IExecutionDisp = dispinterface;
 IExecutionFilter = interface;
 IExecutionFilterDisp = dispinterface;
 IScannerSubscription = interface;
 IScannerSubscriptionDisp = dispinterface;
 IOrderComboLeg = interface;
 IOrderComboLegDisp = dispinterface;
 IOrderComboLegList = interface;
 IOrderComboLegListDisp = dispinterface;
 ICommissionReport = interface;
 ICommissionReportDisp = dispinterface;
 _DTws = dispinterface;
 _DTwsEvents = dispinterface;

//Map CoClass to its default interface

 Tws = _DTws;

//records, unions, aliases


//interface declarations

// IComboLeg : IComboLeg Interface

 IComboLeg = interface(IDispatch)
   ['{573E95CF-F67C-4367-A95B-CB7599BD0673}']
   function Get_conId : Integer; safecall;
   procedure Set_conId(const pVal:Integer); safecall;
   function Get_ratio : Integer; safecall;
   procedure Set_ratio(const pVal:Integer); safecall;
   function Get_action : WideString; safecall;
   procedure Set_action(const pVal:WideString); safecall;
   function Get_exchange : WideString; safecall;
   procedure Set_exchange(const pVal:WideString); safecall;
   function Get_openClose : Integer; safecall;
   procedure Set_openClose(const pVal:Integer); safecall;
   function Get_shortSaleSlot : Integer; safecall;
   procedure Set_shortSaleSlot(const pVal:Integer); safecall;
   function Get_designatedLocation : WideString; safecall;
   procedure Set_designatedLocation(const pVal:WideString); safecall;
   function Get_exemptCode : Integer; safecall;
   procedure Set_exemptCode(const pVal:Integer); safecall;
    // conId : property conId 
   property conId:Integer read Get_conId write Set_conId;
    // ratio : property ratio 
   property ratio:Integer read Get_ratio write Set_ratio;
    // action : property action 
   property action:WideString read Get_action write Set_action;
    // exchange : property exchange 
   property exchange:WideString read Get_exchange write Set_exchange;
    // openClose : property openClose 
   property openClose:Integer read Get_openClose write Set_openClose;
    // shortSaleSlot : property shortSaleSlot 
   property shortSaleSlot:Integer read Get_shortSaleSlot write Set_shortSaleSlot;
    // designatedLocation : property designatedLocation 
   property designatedLocation:WideString read Get_designatedLocation write Set_designatedLocation;
    // exemptCode : property exemptCode 
   property exemptCode:Integer read Get_exemptCode write Set_exemptCode;
  end;


// IComboLeg : IComboLeg Interface

 IComboLegDisp = dispinterface
   ['{573E95CF-F67C-4367-A95B-CB7599BD0673}']
    // conId : property conId 
   property conId:Integer dispid 1;
    // ratio : property ratio 
   property ratio:Integer dispid 2;
    // action : property action 
   property action:WideString dispid 3;
    // exchange : property exchange 
   property exchange:WideString dispid 4;
    // openClose : property openClose 
   property openClose:Integer dispid 5;
    // shortSaleSlot : property shortSaleSlot 
   property shortSaleSlot:Integer dispid 6;
    // designatedLocation : property designatedLocation 
   property designatedLocation:WideString dispid 7;
    // exemptCode : property exemptCode 
   property exemptCode:Integer dispid 8;
  end;


// IComboLegList : IComboLegList Interface

 IComboLegList = interface(IDispatch)
   ['{BE3E5CD3-6F13-4D39-981C-4F75C063C2BA}']
   function Get__NewEnum : IUnknown; safecall;
   function Get_Item(index:Integer) : IDispatch; safecall;
   function Get_Count : Integer; safecall;
    // Add :  
   function Add:IDispatch;safecall;
    // _NewEnum :  
   property _NewEnum:IUnknown read Get__NewEnum;
    // Item :  
   property Item[index:Integer]:IDispatch read Get_Item; default;
    // Count :  
   property Count:Integer read Get_Count;
  end;


// IComboLegList : IComboLegList Interface

 IComboLegListDisp = dispinterface
   ['{BE3E5CD3-6F13-4D39-981C-4F75C063C2BA}']
    // Add :  
   function Add:IDispatch;dispid 2;
    // _NewEnum :  
   property _NewEnum:IUnknown  readonly dispid -4;
    // Item :  
   property Item[index:Integer]:IDispatch  readonly dispid 0; default;
    // Count :  
   property Count:Integer  readonly dispid 1;
  end;


// IUnderComp : IUnderComp Interface

 IUnderComp = interface(IDispatch)
   ['{E5EE73C4-7D45-428E-A347-821CBF918AA6}']
   function Get_conId : Integer; safecall;
   procedure Set_conId(const pVal:Integer); safecall;
   function Get_delta : Double; safecall;
   procedure Set_delta(const pVal:Double); safecall;
   function Get_price : Double; safecall;
   procedure Set_price(const pVal:Double); safecall;
    // conId : property conId 
   property conId:Integer read Get_conId write Set_conId;
    // delta : property delta 
   property delta:Double read Get_delta write Set_delta;
    // price : property price 
   property price:Double read Get_price write Set_price;
  end;


// IUnderComp : IUnderComp Interface

 IUnderCompDisp = dispinterface
   ['{E5EE73C4-7D45-428E-A347-821CBF918AA6}']
    // conId : property conId 
   property conId:Integer dispid 1;
    // delta : property delta 
   property delta:Double dispid 2;
    // price : property price 
   property price:Double dispid 3;
  end;


// IContract : IContract Interface

 IContract = interface(IDispatch)
   ['{AE6A66F3-8FA9-4076-9C1F-3728B10A4CC7}']
   function Get_conId : Integer; safecall;
   procedure Set_conId(const pVal:Integer); safecall;
   function Get_symbol : WideString; safecall;
   procedure Set_symbol(const pVal:WideString); safecall;
   function Get_secType : WideString; safecall;
   procedure Set_secType(const pVal:WideString); safecall;
   function Get_expiry : WideString; safecall;
   procedure Set_expiry(const pVal:WideString); safecall;
   function Get_strike : Double; safecall;
   procedure Set_strike(const pVal:Double); safecall;
   function Get_right : WideString; safecall;
   procedure Set_right(const pVal:WideString); safecall;
   function Get_multiplier : WideString; safecall;
   procedure Set_multiplier(const pVal:WideString); safecall;
   function Get_exchange : WideString; safecall;
   procedure Set_exchange(const pVal:WideString); safecall;
   function Get_primaryExchange : WideString; safecall;
   procedure Set_primaryExchange(const pVal:WideString); safecall;
   function Get_currency : WideString; safecall;
   procedure Set_currency(const pVal:WideString); safecall;
   function Get_localSymbol : WideString; safecall;
   procedure Set_localSymbol(const pVal:WideString); safecall;
   function Get_tradingClass : WideString; safecall;
   procedure Set_tradingClass(const pVal:WideString); safecall;
   function Get_includeExpired : Integer; safecall;
   procedure Set_includeExpired(const pVal:Integer); safecall;
   function Get_comboLegs : IDispatch; safecall;
   procedure Set_comboLegs(const pVal:IDispatch); safecall;
   function Get_underComp : IDispatch; safecall;
   procedure Set_underComp(const pVal:IDispatch); safecall;
   function Get_comboLegsDescrip : WideString; safecall;
   function Get_secIdType : WideString; safecall;
   procedure Set_secIdType(const pVal:WideString); safecall;
   function Get_secId : WideString; safecall;
   procedure Set_secId(const pVal:WideString); safecall;
    // conId : property conId 
   property conId:Integer read Get_conId write Set_conId;
    // symbol : property symbol 
   property symbol:WideString read Get_symbol write Set_symbol;
    // secType : property secType 
   property secType:WideString read Get_secType write Set_secType;
    // expiry : property expiry 
   property expiry:WideString read Get_expiry write Set_expiry;
    // strike : property strike 
   property strike:Double read Get_strike write Set_strike;
    // right : property right 
   property right:WideString read Get_right write Set_right;
    // multiplier : property multiplier 
   property multiplier:WideString read Get_multiplier write Set_multiplier;
    // exchange : property exchange 
   property exchange:WideString read Get_exchange write Set_exchange;
    // primaryExchange : property primaryExchange 
   property primaryExchange:WideString read Get_primaryExchange write Set_primaryExchange;
    // currency : property currency 
   property currency:WideString read Get_currency write Set_currency;
    // localSymbol : property localSymbol 
   property localSymbol:WideString read Get_localSymbol write Set_localSymbol;
    // tradingClass : property tradingClass 
   property tradingClass:WideString read Get_tradingClass write Set_tradingClass;
    // includeExpired : property includeExpired 
   property includeExpired:Integer read Get_includeExpired write Set_includeExpired;
    // comboLegs : property comboLegs 
   property comboLegs:IDispatch read Get_comboLegs write Set_comboLegs;
    // underComp : property underComp 
   property underComp:IDispatch read Get_underComp write Set_underComp;
    // comboLegsDescrip : property comboLegsDescrip 
   property comboLegsDescrip:WideString read Get_comboLegsDescrip;
    // secIdType : property secIdType 
   property secIdType:WideString read Get_secIdType write Set_secIdType;
    // secId : property secId 
   property secId:WideString read Get_secId write Set_secId;
  end;


// IContract : IContract Interface

 IContractDisp = dispinterface
   ['{AE6A66F3-8FA9-4076-9C1F-3728B10A4CC7}']
    // conId : property conId 
   property conId:Integer dispid 1;
    // symbol : property symbol 
   property symbol:WideString dispid 2;
    // secType : property secType 
   property secType:WideString dispid 3;
    // expiry : property expiry 
   property expiry:WideString dispid 4;
    // strike : property strike 
   property strike:Double dispid 5;
    // right : property right 
   property right:WideString dispid 6;
    // multiplier : property multiplier 
   property multiplier:WideString dispid 7;
    // exchange : property exchange 
   property exchange:WideString dispid 8;
    // primaryExchange : property primaryExchange 
   property primaryExchange:WideString dispid 9;
    // currency : property currency 
   property currency:WideString dispid 10;
    // localSymbol : property localSymbol 
   property localSymbol:WideString dispid 11;
    // tradingClass : property tradingClass 
   property tradingClass:WideString dispid 12;
    // includeExpired : property includeExpired 
   property includeExpired:Integer dispid 13;
    // comboLegs : property comboLegs 
   property comboLegs:IDispatch dispid 14;
    // underComp : property underComp 
   property underComp:IDispatch dispid 15;
    // comboLegsDescrip : property comboLegsDescrip 
   property comboLegsDescrip:WideString  readonly dispid 16;
    // secIdType : property secIdType 
   property secIdType:WideString dispid 17;
    // secId : property secId 
   property secId:WideString dispid 18;
  end;


// IContractDetails : IContractDetails Interface

 IContractDetails = interface(IDispatch)
   ['{64F03988-ED93-452E-830B-3420DF21BAF9}']
   function Get_marketName : WideString; safecall;
   function Get_minTick : Double; safecall;
   function Get_priceMagnifier : Integer; safecall;
   function Get_orderTypes : WideString; safecall;
   function Get_validExchanges : WideString; safecall;
   function Get_underConId : Integer; safecall;
   function Get_longName : WideString; safecall;
   function Get_contractMonth : WideString; safecall;
   function Get_industry : WideString; safecall;
   function Get_category : WideString; safecall;
   function Get_subcategory : WideString; safecall;
   function Get_timeZoneId : WideString; safecall;
   function Get_tradingHours : WideString; safecall;
   function Get_liquidHours : WideString; safecall;
   function Get_summary : IDispatch; safecall;
   function Get_secIdList : IDispatch; safecall;
   function Get_cusip : WideString; safecall;
   function Get_ratings : WideString; safecall;
   function Get_descAppend : WideString; safecall;
   function Get_bondType : WideString; safecall;
   function Get_couponType : WideString; safecall;
   function Get_callable : Integer; safecall;
   function Get_putable : Integer; safecall;
   function Get_coupon : Double; safecall;
   function Get_convertible : Integer; safecall;
   function Get_maturity : WideString; safecall;
   function Get_issueDate : WideString; safecall;
   function Get_nextOptionDate : WideString; safecall;
   function Get_nextOptionType : WideString; safecall;
   function Get_nextOptionPartial : Integer; safecall;
   function Get_notes : WideString; safecall;
   function Get_evRule : WideString; safecall;
   function Get_evMultiplier : Double; safecall;
    // marketName : property marketName 
   property marketName:WideString read Get_marketName;
    // minTick : property minTick 
   property minTick:Double read Get_minTick;
    // priceMagnifier : property priceMagnifier 
   property priceMagnifier:Integer read Get_priceMagnifier;
    // orderTypes : property orderTypes 
   property orderTypes:WideString read Get_orderTypes;
    // validExchanges : property validExchanges 
   property validExchanges:WideString read Get_validExchanges;
    // underConId : property underConId 
   property underConId:Integer read Get_underConId;
    // longName : property longName 
   property longName:WideString read Get_longName;
    // contractMonth : property contractMonth 
   property contractMonth:WideString read Get_contractMonth;
    // industry : property industry 
   property industry:WideString read Get_industry;
    // category : property category 
   property category:WideString read Get_category;
    // subcategory : property subcategory 
   property subcategory:WideString read Get_subcategory;
    // timeZoneId : property timeZoneId 
   property timeZoneId:WideString read Get_timeZoneId;
    // tradingHours : property tradingHours 
   property tradingHours:WideString read Get_tradingHours;
    // liquidHours : property liquidHours 
   property liquidHours:WideString read Get_liquidHours;
    // summary : property summary 
   property summary:IDispatch read Get_summary;
    // secIdList : property secIdList 
   property secIdList:IDispatch read Get_secIdList;
    // cusip : property cusip 
   property cusip:WideString read Get_cusip;
    // ratings : property ratings 
   property ratings:WideString read Get_ratings;
    // descAppend : property descAppend 
   property descAppend:WideString read Get_descAppend;
    // bondType : property bondType 
   property bondType:WideString read Get_bondType;
    // couponType : property couponType 
   property couponType:WideString read Get_couponType;
    // callable : property callable 
   property callable:Integer read Get_callable;
    // putable : property putable 
   property putable:Integer read Get_putable;
    // coupon : property coupon 
   property coupon:Double read Get_coupon;
    // convertible : property convertible 
   property convertible:Integer read Get_convertible;
    // maturity : property maturity 
   property maturity:WideString read Get_maturity;
    // issueDate : property issueDate 
   property issueDate:WideString read Get_issueDate;
    // nextOptionDate : property nextOptionDate 
   property nextOptionDate:WideString read Get_nextOptionDate;
    // nextOptionType : property nextOptionType 
   property nextOptionType:WideString read Get_nextOptionType;
    // nextOptionPartial : property nextOptionPartial 
   property nextOptionPartial:Integer read Get_nextOptionPartial;
    // notes : property notes 
   property notes:WideString read Get_notes;
    // evRule : property evRule 
   property evRule:WideString read Get_evRule;
    // evMultiplier : property evMultiplier 
   property evMultiplier:Double read Get_evMultiplier;
  end;


// IContractDetails : IContractDetails Interface

 IContractDetailsDisp = dispinterface
   ['{64F03988-ED93-452E-830B-3420DF21BAF9}']
    // marketName : property marketName 
   property marketName:WideString  readonly dispid 1;
    // minTick : property minTick 
   property minTick:Double  readonly dispid 3;
    // priceMagnifier : property priceMagnifier 
   property priceMagnifier:Integer  readonly dispid 4;
    // orderTypes : property orderTypes 
   property orderTypes:WideString  readonly dispid 5;
    // validExchanges : property validExchanges 
   property validExchanges:WideString  readonly dispid 6;
    // underConId : property underConId 
   property underConId:Integer  readonly dispid 7;
    // longName : property longName 
   property longName:WideString  readonly dispid 8;
    // contractMonth : property contractMonth 
   property contractMonth:WideString  readonly dispid 9;
    // industry : property industry 
   property industry:WideString  readonly dispid 10;
    // category : property category 
   property category:WideString  readonly dispid 11;
    // subcategory : property subcategory 
   property subcategory:WideString  readonly dispid 12;
    // timeZoneId : property timeZoneId 
   property timeZoneId:WideString  readonly dispid 13;
    // tradingHours : property tradingHours 
   property tradingHours:WideString  readonly dispid 14;
    // liquidHours : property liquidHours 
   property liquidHours:WideString  readonly dispid 15;
    // summary : property summary 
   property summary:IDispatch  readonly dispid 16;
    // secIdList : property secIdList 
   property secIdList:IDispatch  readonly dispid 17;
    // cusip : property cusip 
   property cusip:WideString  readonly dispid 20;
    // ratings : property ratings 
   property ratings:WideString  readonly dispid 21;
    // descAppend : property descAppend 
   property descAppend:WideString  readonly dispid 22;
    // bondType : property bondType 
   property bondType:WideString  readonly dispid 23;
    // couponType : property couponType 
   property couponType:WideString  readonly dispid 24;
    // callable : property callable 
   property callable:Integer  readonly dispid 25;
    // putable : property putable 
   property putable:Integer  readonly dispid 26;
    // coupon : property coupon 
   property coupon:Double  readonly dispid 27;
    // convertible : property convertible 
   property convertible:Integer  readonly dispid 28;
    // maturity : property maturity 
   property maturity:WideString  readonly dispid 29;
    // issueDate : property issueDate 
   property issueDate:WideString  readonly dispid 30;
    // nextOptionDate : property nextOptionDate 
   property nextOptionDate:WideString  readonly dispid 31;
    // nextOptionType : property nextOptionType 
   property nextOptionType:WideString  readonly dispid 32;
    // nextOptionPartial : property nextOptionPartial 
   property nextOptionPartial:Integer  readonly dispid 33;
    // notes : property notes 
   property notes:WideString  readonly dispid 34;
    // evRule : property evRule 
   property evRule:WideString  readonly dispid 35;
    // evMultiplier : property evMultiplier 
   property evMultiplier:Double  readonly dispid 36;
  end;


// ITagValue : ITagValue Interface

 ITagValue = interface(IDispatch)
   ['{06FF1D3F-F12F-47D1-9443-A74D3CD58723}']
   function Get_tag : WideString; safecall;
   procedure Set_tag(const pVal:WideString); safecall;
   function Get_value : WideString; safecall;
   procedure Set_value(const pVal:WideString); safecall;
    // tag : property tag 
   property tag:WideString read Get_tag write Set_tag;
    // value : property value 
   property value:WideString read Get_value write Set_value;
  end;


// ITagValue : ITagValue Interface

 ITagValueDisp = dispinterface
   ['{06FF1D3F-F12F-47D1-9443-A74D3CD58723}']
    // tag : property tag 
   property tag:WideString dispid 1;
    // value : property value 
   property value:WideString dispid 2;
  end;


// ITagValueList : ITagValueList Interface

 ITagValueList = interface(IDispatch)
   ['{CC48E64E-C1A7-4867-8738-578404D75088}']
   function Get__NewEnum : IUnknown; safecall;
   function Get_Item(index:Integer) : IDispatch; safecall;
   function Get_Count : Integer; safecall;
    // AddEmpty :  
   function AddEmpty:IDispatch;safecall;
    // Add :  
   function Add(tag:WideString;value:WideString):IDispatch;safecall;
    // _NewEnum :  
   property _NewEnum:IUnknown read Get__NewEnum;
    // Item :  
   property Item[index:Integer]:IDispatch read Get_Item; default;
    // Count :  
   property Count:Integer read Get_Count;
  end;


// ITagValueList : ITagValueList Interface

 ITagValueListDisp = dispinterface
   ['{CC48E64E-C1A7-4867-8738-578404D75088}']
    // AddEmpty :  
   function AddEmpty:IDispatch;dispid 2;
    // Add :  
   function Add(tag:WideString;value:WideString):IDispatch;dispid 3;
    // _NewEnum :  
   property _NewEnum:IUnknown  readonly dispid -4;
    // Item :  
   property Item[index:Integer]:IDispatch  readonly dispid 0; default;
    // Count :  
   property Count:Integer  readonly dispid 1;
  end;


// IOrder : IOrder Interface

 IOrder = interface(IDispatch)
   ['{25D97F3D-2C4D-4080-9250-D2FB8071BE58}']
   function Get_orderId : Integer; safecall;
   procedure Set_orderId(const pVal:Integer); safecall;
   function Get_clientId : Integer; safecall;
   procedure Set_clientId(const pVal:Integer); safecall;
   function Get_permId : Integer; safecall;
   procedure Set_permId(const pVal:Integer); safecall;
   function Get_action : WideString; safecall;
   procedure Set_action(const pVal:WideString); safecall;
   function Get_totalQuantity : Integer; safecall;
   procedure Set_totalQuantity(const pVal:Integer); safecall;
   function Get_orderType : WideString; safecall;
   procedure Set_orderType(const pVal:WideString); safecall;
   function Get_lmtPrice : Double; safecall;
   procedure Set_lmtPrice(const pVal:Double); safecall;
   function Get_auxPrice : Double; safecall;
   procedure Set_auxPrice(const pVal:Double); safecall;
   function Get_timeInForce : WideString; safecall;
   procedure Set_timeInForce(const pVal:WideString); safecall;
   function Get_activeStartTime : WideString; safecall;
   procedure Set_activeStartTime(const pVal:WideString); safecall;
   function Get_activeStopTime : WideString; safecall;
   procedure Set_activeStopTime(const pVal:WideString); safecall;
   function Get_ocaGroup : WideString; safecall;
   procedure Set_ocaGroup(const pVal:WideString); safecall;
   function Get_ocaType : Integer; safecall;
   procedure Set_ocaType(const pVal:Integer); safecall;
   function Get_orderRef : WideString; safecall;
   procedure Set_orderRef(const pVal:WideString); safecall;
   function Get_transmit : Integer; safecall;
   procedure Set_transmit(const pVal:Integer); safecall;
   function Get_parentId : Integer; safecall;
   procedure Set_parentId(const pVal:Integer); safecall;
   function Get_blockOrder : Integer; safecall;
   procedure Set_blockOrder(const pVal:Integer); safecall;
   function Get_sweepToFill : Integer; safecall;
   procedure Set_sweepToFill(const pVal:Integer); safecall;
   function Get_displaySize : Integer; safecall;
   procedure Set_displaySize(const pVal:Integer); safecall;
   function Get_triggerMethod : Integer; safecall;
   procedure Set_triggerMethod(const pVal:Integer); safecall;
   function Get_outsideRth : Integer; safecall;
   procedure Set_outsideRth(const pVal:Integer); safecall;
   function Get_hidden : Integer; safecall;
   procedure Set_hidden(const pVal:Integer); safecall;
   function Get_goodAfterTime : WideString; safecall;
   procedure Set_goodAfterTime(const pVal:WideString); safecall;
   function Get_goodTillDate : WideString; safecall;
   procedure Set_goodTillDate(const pVal:WideString); safecall;
   function Get_overridePercentageConstraints : Integer; safecall;
   procedure Set_overridePercentageConstraints(const pVal:Integer); safecall;
   function Get_rule80A : WideString; safecall;
   procedure Set_rule80A(const pVal:WideString); safecall;
   function Get_allOrNone : Integer; safecall;
   procedure Set_allOrNone(const pVal:Integer); safecall;
   function Get_minQty : Integer; safecall;
   procedure Set_minQty(const pVal:Integer); safecall;
   function Get_percentOffset : Double; safecall;
   procedure Set_percentOffset(const pVal:Double); safecall;
   function Get_trailStopPrice : Double; safecall;
   procedure Set_trailStopPrice(const pVal:Double); safecall;
   function Get_trailingPercent : Double; safecall;
   procedure Set_trailingPercent(const pVal:Double); safecall;
   function Get_whatIf : Integer; safecall;
   procedure Set_whatIf(const pVal:Integer); safecall;
   function Get_notHeld : Integer; safecall;
   procedure Set_notHeld(const pVal:Integer); safecall;
   function Get_faGroup : WideString; safecall;
   procedure Set_faGroup(const pVal:WideString); safecall;
   function Get_faProfile : WideString; safecall;
   procedure Set_faProfile(const pVal:WideString); safecall;
   function Get_faMethod : WideString; safecall;
   procedure Set_faMethod(const pVal:WideString); safecall;
   function Get_faPercentage : WideString; safecall;
   procedure Set_faPercentage(const pVal:WideString); safecall;
   function Get_openClose : WideString; safecall;
   procedure Set_openClose(const pVal:WideString); safecall;
   function Get_origin : Integer; safecall;
   procedure Set_origin(const pVal:Integer); safecall;
   function Get_shortSaleSlot : Integer; safecall;
   procedure Set_shortSaleSlot(const pVal:Integer); safecall;
   function Get_designatedLocation : WideString; safecall;
   procedure Set_designatedLocation(const pVal:WideString); safecall;
   function Get_exemptCode : Integer; safecall;
   procedure Set_exemptCode(const pVal:Integer); safecall;
   function Get_discretionaryAmt : Double; safecall;
   procedure Set_discretionaryAmt(const pVal:Double); safecall;
   function Get_eTradeOnly : Integer; safecall;
   procedure Set_eTradeOnly(const pVal:Integer); safecall;
   function Get_firmQuoteOnly : Integer; safecall;
   procedure Set_firmQuoteOnly(const pVal:Integer); safecall;
   function Get_nbboPriceCap : Double; safecall;
   procedure Set_nbboPriceCap(const pVal:Double); safecall;
   function Get_optOutSmartRouting : Integer; safecall;
   procedure Set_optOutSmartRouting(const pVal:Integer); safecall;
   function Get_auctionStrategy : Integer; safecall;
   procedure Set_auctionStrategy(const pVal:Integer); safecall;
   function Get_startingPrice : Double; safecall;
   procedure Set_startingPrice(const pVal:Double); safecall;
   function Get_stockRefPrice : Double; safecall;
   procedure Set_stockRefPrice(const pVal:Double); safecall;
   function Get_delta : Double; safecall;
   procedure Set_delta(const pVal:Double); safecall;
   function Get_stockRangeLower : Double; safecall;
   procedure Set_stockRangeLower(const pVal:Double); safecall;
   function Get_stockRangeUpper : Double; safecall;
   procedure Set_stockRangeUpper(const pVal:Double); safecall;
   function Get_volatility : Double; safecall;
   procedure Set_volatility(const pVal:Double); safecall;
   function Get_volatilityType : Integer; safecall;
   procedure Set_volatilityType(const pVal:Integer); safecall;
   function Get_continuousUpdate : Integer; safecall;
   procedure Set_continuousUpdate(const pVal:Integer); safecall;
   function Get_referencePriceType : Integer; safecall;
   procedure Set_referencePriceType(const pVal:Integer); safecall;
   function Get_deltaNeutralOrderType : WideString; safecall;
   procedure Set_deltaNeutralOrderType(const pVal:WideString); safecall;
   function Get_deltaNeutralAuxPrice : Double; safecall;
   procedure Set_deltaNeutralAuxPrice(const pVal:Double); safecall;
   function Get_deltaNeutralConId : Integer; safecall;
   procedure Set_deltaNeutralConId(const pVal:Integer); safecall;
   function Get_deltaNeutralSettlingFirm : WideString; safecall;
   procedure Set_deltaNeutralSettlingFirm(const pVal:WideString); safecall;
   function Get_deltaNeutralClearingAccount : WideString; safecall;
   procedure Set_deltaNeutralClearingAccount(const pVal:WideString); safecall;
   function Get_deltaNeutralClearingIntent : WideString; safecall;
   procedure Set_deltaNeutralClearingIntent(const pVal:WideString); safecall;
   function Get_deltaNeutralOpenClose : WideString; safecall;
   procedure Set_deltaNeutralOpenClose(const pVal:WideString); safecall;
   function Get_deltaNeutralShortSale : Integer; safecall;
   procedure Set_deltaNeutralShortSale(const pVal:Integer); safecall;
   function Get_deltaNeutralShortSaleSlot : Integer; safecall;
   procedure Set_deltaNeutralShortSaleSlot(const pVal:Integer); safecall;
   function Get_deltaNeutralDesignatedLocation : WideString; safecall;
   procedure Set_deltaNeutralDesignatedLocation(const pVal:WideString); safecall;
   function Get_basisPoints : Double; safecall;
   procedure Set_basisPoints(const pVal:Double); safecall;
   function Get_basisPointsType : Integer; safecall;
   procedure Set_basisPointsType(const pVal:Integer); safecall;
   function Get_scaleInitLevelSize : Integer; safecall;
   procedure Set_scaleInitLevelSize(const pVal:Integer); safecall;
   function Get_scaleSubsLevelSize : Integer; safecall;
   procedure Set_scaleSubsLevelSize(const pVal:Integer); safecall;
   function Get_scalePriceIncrement : Double; safecall;
   procedure Set_scalePriceIncrement(const pVal:Double); safecall;
   function Get_scalePriceAdjustValue : Double; safecall;
   procedure Set_scalePriceAdjustValue(const pVal:Double); safecall;
   function Get_scalePriceAdjustInterval : Integer; safecall;
   procedure Set_scalePriceAdjustInterval(const pVal:Integer); safecall;
   function Get_scaleProfitOffset : Double; safecall;
   procedure Set_scaleProfitOffset(const pVal:Double); safecall;
   function Get_scaleAutoReset : Integer; safecall;
   procedure Set_scaleAutoReset(const pVal:Integer); safecall;
   function Get_scaleInitPosition : Integer; safecall;
   procedure Set_scaleInitPosition(const pVal:Integer); safecall;
   function Get_scaleInitFillQty : Integer; safecall;
   procedure Set_scaleInitFillQty(const pVal:Integer); safecall;
   function Get_scaleRandomPercent : Integer; safecall;
   procedure Set_scaleRandomPercent(const pVal:Integer); safecall;
   function Get_scaleTable : WideString; safecall;
   procedure Set_scaleTable(const pVal:WideString); safecall;
   function Get_hedgeType : WideString; safecall;
   procedure Set_hedgeType(const pVal:WideString); safecall;
   function Get_hedgeParam : WideString; safecall;
   procedure Set_hedgeParam(const pVal:WideString); safecall;
   function Get_account : WideString; safecall;
   procedure Set_account(const pVal:WideString); safecall;
   function Get_settlingFirm : WideString; safecall;
   procedure Set_settlingFirm(const pVal:WideString); safecall;
   function Get_clearingAccount : WideString; safecall;
   procedure Set_clearingAccount(const pVal:WideString); safecall;
   function Get_clearingIntent : WideString; safecall;
   procedure Set_clearingIntent(const pVal:WideString); safecall;
   function Get_algoStrategy : WideString; safecall;
   procedure Set_algoStrategy(const pVal:WideString); safecall;
   function Get_algoParams : IDispatch; safecall;
   procedure Set_algoParams(const pVal:IDispatch); safecall;
   function Get_smartComboRoutingParams : IDispatch; safecall;
   procedure Set_smartComboRoutingParams(const pVal:IDispatch); safecall;
   function Get_orderComboLegs : IDispatch; safecall;
   procedure Set_orderComboLegs(const pVal:IDispatch); safecall;
   function Get_orderMiscOptions : IDispatch; safecall;
   procedure Set_orderMiscOptions(const pVal:IDispatch); safecall;
    // orderId : property orderId 
   property orderId:Integer read Get_orderId write Set_orderId;
    // clientId : property clientId 
   property clientId:Integer read Get_clientId write Set_clientId;
    // permId : property permId 
   property permId:Integer read Get_permId write Set_permId;
    // action : property action 
   property action:WideString read Get_action write Set_action;
    // totalQuantity : property totalQuantity 
   property totalQuantity:Integer read Get_totalQuantity write Set_totalQuantity;
    // orderType : property orderType 
   property orderType:WideString read Get_orderType write Set_orderType;
    // lmtPrice : property lmtPrice 
   property lmtPrice:Double read Get_lmtPrice write Set_lmtPrice;
    // auxPrice : property auxPrice 
   property auxPrice:Double read Get_auxPrice write Set_auxPrice;
    // timeInForce : property timeInForce 
   property timeInForce:WideString read Get_timeInForce write Set_timeInForce;
    // activeStartTime : property activeStartTime 
   property activeStartTime:WideString read Get_activeStartTime write Set_activeStartTime;
    // activeStopTime : property activeStopTime 
   property activeStopTime:WideString read Get_activeStopTime write Set_activeStopTime;
    // ocaGroup : property ocaGroup 
   property ocaGroup:WideString read Get_ocaGroup write Set_ocaGroup;
    // ocaType : property ocaType 
   property ocaType:Integer read Get_ocaType write Set_ocaType;
    // orderRef : property orderRef 
   property orderRef:WideString read Get_orderRef write Set_orderRef;
    // transmit : property transmit 
   property transmit:Integer read Get_transmit write Set_transmit;
    // parentId : property parentId 
   property parentId:Integer read Get_parentId write Set_parentId;
    // blockOrder : property blockOrder 
   property blockOrder:Integer read Get_blockOrder write Set_blockOrder;
    // sweepToFill : property sweepToFill 
   property sweepToFill:Integer read Get_sweepToFill write Set_sweepToFill;
    // displaySize : property displaySize 
   property displaySize:Integer read Get_displaySize write Set_displaySize;
    // triggerMethod : property triggerMethod 
   property triggerMethod:Integer read Get_triggerMethod write Set_triggerMethod;
    // outsideRth : property outsideRth 
   property outsideRth:Integer read Get_outsideRth write Set_outsideRth;
    // hidden : property hidden 
   property hidden:Integer read Get_hidden write Set_hidden;
    // goodAfterTime : property goodAfterTime 
   property goodAfterTime:WideString read Get_goodAfterTime write Set_goodAfterTime;
    // goodTillDate : property goodTillDate 
   property goodTillDate:WideString read Get_goodTillDate write Set_goodTillDate;
    // overridePercentageConstraints : property overridePercentageConstraints 
   property overridePercentageConstraints:Integer read Get_overridePercentageConstraints write Set_overridePercentageConstraints;
    // rule80A : property rule80A 
   property rule80A:WideString read Get_rule80A write Set_rule80A;
    // allOrNone : property allOrNone 
   property allOrNone:Integer read Get_allOrNone write Set_allOrNone;
    // minQty : property minQty 
   property minQty:Integer read Get_minQty write Set_minQty;
    // percentOffset : property percentOffset 
   property percentOffset:Double read Get_percentOffset write Set_percentOffset;
    // trailStopPrice : property trailStopPrice 
   property trailStopPrice:Double read Get_trailStopPrice write Set_trailStopPrice;
    // trailingPercent : property trailingPercent 
   property trailingPercent:Double read Get_trailingPercent write Set_trailingPercent;
    // whatIf : property whatIf 
   property whatIf:Integer read Get_whatIf write Set_whatIf;
    // notHeld : property notHeld 
   property notHeld:Integer read Get_notHeld write Set_notHeld;
    // faGroup : property faGroup 
   property faGroup:WideString read Get_faGroup write Set_faGroup;
    // faProfile : property faProfile 
   property faProfile:WideString read Get_faProfile write Set_faProfile;
    // faMethod : property faMethod 
   property faMethod:WideString read Get_faMethod write Set_faMethod;
    // faPercentage : property faPercentage 
   property faPercentage:WideString read Get_faPercentage write Set_faPercentage;
    // openClose : property openClose 
   property openClose:WideString read Get_openClose write Set_openClose;
    // origin : property origin 
   property origin:Integer read Get_origin write Set_origin;
    // shortSaleSlot : property shortSaleSlot 
   property shortSaleSlot:Integer read Get_shortSaleSlot write Set_shortSaleSlot;
    // designatedLocation : property designatedLocation 
   property designatedLocation:WideString read Get_designatedLocation write Set_designatedLocation;
    // exemptCode : property exemptCode 
   property exemptCode:Integer read Get_exemptCode write Set_exemptCode;
    // discretionaryAmt : property discretionaryAmt 
   property discretionaryAmt:Double read Get_discretionaryAmt write Set_discretionaryAmt;
    // eTradeOnly : property eTradeOnly 
   property eTradeOnly:Integer read Get_eTradeOnly write Set_eTradeOnly;
    // firmQuoteOnly : property firmQuoteOnly 
   property firmQuoteOnly:Integer read Get_firmQuoteOnly write Set_firmQuoteOnly;
    // nbboPriceCap : property nbboPriceCap 
   property nbboPriceCap:Double read Get_nbboPriceCap write Set_nbboPriceCap;
    // optOutSmartRouting : property optOutSmartRouting 
   property optOutSmartRouting:Integer read Get_optOutSmartRouting write Set_optOutSmartRouting;
    // auctionStrategy : property auctionStrategy 
   property auctionStrategy:Integer read Get_auctionStrategy write Set_auctionStrategy;
    // startingPrice : property startingPrice 
   property startingPrice:Double read Get_startingPrice write Set_startingPrice;
    // stockRefPrice : property stockRefPrice 
   property stockRefPrice:Double read Get_stockRefPrice write Set_stockRefPrice;
    // delta : property delta 
   property delta:Double read Get_delta write Set_delta;
    // stockRangeLower : property stockRangeLower 
   property stockRangeLower:Double read Get_stockRangeLower write Set_stockRangeLower;
    // stockRangeUpper : property stockRangeUpper 
   property stockRangeUpper:Double read Get_stockRangeUpper write Set_stockRangeUpper;
    // volatility : property volatility 
   property volatility:Double read Get_volatility write Set_volatility;
    // volatilityType : property volatilityType 
   property volatilityType:Integer read Get_volatilityType write Set_volatilityType;
    // continuousUpdate : property continuousUpdate 
   property continuousUpdate:Integer read Get_continuousUpdate write Set_continuousUpdate;
    // referencePriceType : property referencePriceType 
   property referencePriceType:Integer read Get_referencePriceType write Set_referencePriceType;
    // deltaNeutralOrderType : property deltaNeutralOrderType 
   property deltaNeutralOrderType:WideString read Get_deltaNeutralOrderType write Set_deltaNeutralOrderType;
    // deltaNeutralAuxPrice : property deltaNeutralAuxPrice 
   property deltaNeutralAuxPrice:Double read Get_deltaNeutralAuxPrice write Set_deltaNeutralAuxPrice;
    // deltaNeutralConId : property deltaNeutralConId 
   property deltaNeutralConId:Integer read Get_deltaNeutralConId write Set_deltaNeutralConId;
    // deltaNeutralSettlingFirm : property deltaNeutralSettlingFirm 
   property deltaNeutralSettlingFirm:WideString read Get_deltaNeutralSettlingFirm write Set_deltaNeutralSettlingFirm;
    // deltaNeutralClearingAccount : property deltaNeutralClearingAccount 
   property deltaNeutralClearingAccount:WideString read Get_deltaNeutralClearingAccount write Set_deltaNeutralClearingAccount;
    // deltaNeutralClearingIntent : property deltaNeutralClearingIntent 
   property deltaNeutralClearingIntent:WideString read Get_deltaNeutralClearingIntent write Set_deltaNeutralClearingIntent;
    // deltaNeutralOpenClose : property deltaNeutralOpenClose 
   property deltaNeutralOpenClose:WideString read Get_deltaNeutralOpenClose write Set_deltaNeutralOpenClose;
    // deltaNeutralShortSale : property deltaNeutralShortSale 
   property deltaNeutralShortSale:Integer read Get_deltaNeutralShortSale write Set_deltaNeutralShortSale;
    // deltaNeutralShortSaleSlot : property deltaNeutralShortSaleSlot 
   property deltaNeutralShortSaleSlot:Integer read Get_deltaNeutralShortSaleSlot write Set_deltaNeutralShortSaleSlot;
    // deltaNeutralDesignatedLocation : property deltaNeutralDesignatedLocation 
   property deltaNeutralDesignatedLocation:WideString read Get_deltaNeutralDesignatedLocation write Set_deltaNeutralDesignatedLocation;
    // basisPoints : property basisPoints 
   property basisPoints:Double read Get_basisPoints write Set_basisPoints;
    // basisPointsType : property basisPointsType 
   property basisPointsType:Integer read Get_basisPointsType write Set_basisPointsType;
    // scaleInitLevelSize : property scaleInitLevelSize 
   property scaleInitLevelSize:Integer read Get_scaleInitLevelSize write Set_scaleInitLevelSize;
    // scaleSubsLevelSize : property scaleSubsLevelSize 
   property scaleSubsLevelSize:Integer read Get_scaleSubsLevelSize write Set_scaleSubsLevelSize;
    // scalePriceIncrement : property scalePriceIncrement 
   property scalePriceIncrement:Double read Get_scalePriceIncrement write Set_scalePriceIncrement;
    // scalePriceAdjustValue : property scalePriceAdjustValue 
   property scalePriceAdjustValue:Double read Get_scalePriceAdjustValue write Set_scalePriceAdjustValue;
    // scalePriceAdjustInterval : property scalePriceAdjustInterval 
   property scalePriceAdjustInterval:Integer read Get_scalePriceAdjustInterval write Set_scalePriceAdjustInterval;
    // scaleProfitOffset : property scaleProfitOffset 
   property scaleProfitOffset:Double read Get_scaleProfitOffset write Set_scaleProfitOffset;
    // scaleAutoReset : property scaleAutoReset 
   property scaleAutoReset:Integer read Get_scaleAutoReset write Set_scaleAutoReset;
    // scaleInitPosition : property scaleInitPosition 
   property scaleInitPosition:Integer read Get_scaleInitPosition write Set_scaleInitPosition;
    // scaleInitFillQty : property scaleInitFillQty 
   property scaleInitFillQty:Integer read Get_scaleInitFillQty write Set_scaleInitFillQty;
    // scaleRandomPercent : property scaleRandomPercent 
   property scaleRandomPercent:Integer read Get_scaleRandomPercent write Set_scaleRandomPercent;
    // scaleTable : property scaleTable 
   property scaleTable:WideString read Get_scaleTable write Set_scaleTable;
    // hedgeType : property hedgeType 
   property hedgeType:WideString read Get_hedgeType write Set_hedgeType;
    // hedgeParam : property hedgeParam 
   property hedgeParam:WideString read Get_hedgeParam write Set_hedgeParam;
    // account : property account 
   property account:WideString read Get_account write Set_account;
    // settlingFirm : property settlingFirm 
   property settlingFirm:WideString read Get_settlingFirm write Set_settlingFirm;
    // clearingAccount : property clearingAccount 
   property clearingAccount:WideString read Get_clearingAccount write Set_clearingAccount;
    // clearingIntent : property clearingIntent 
   property clearingIntent:WideString read Get_clearingIntent write Set_clearingIntent;
    // algoStrategy : property algoStrategy 
   property algoStrategy:WideString read Get_algoStrategy write Set_algoStrategy;
    // algoParams : property algoParams 
   property algoParams:IDispatch read Get_algoParams write Set_algoParams;
    // smartComboRoutingParams : property smartComboRoutingParams 
   property smartComboRoutingParams:IDispatch read Get_smartComboRoutingParams write Set_smartComboRoutingParams;
    // orderComboLegs : property orderComboLegs 
   property orderComboLegs:IDispatch read Get_orderComboLegs write Set_orderComboLegs;
    // orderMiscOptions : property orderMiscOptions 
   property orderMiscOptions:IDispatch read Get_orderMiscOptions write Set_orderMiscOptions;
  end;


// IOrder : IOrder Interface

 IOrderDisp = dispinterface
   ['{25D97F3D-2C4D-4080-9250-D2FB8071BE58}']
    // orderId : property orderId 
   property orderId:Integer dispid 1;
    // clientId : property clientId 
   property clientId:Integer dispid 2;
    // permId : property permId 
   property permId:Integer dispid 3;
    // action : property action 
   property action:WideString dispid 4;
    // totalQuantity : property totalQuantity 
   property totalQuantity:Integer dispid 5;
    // orderType : property orderType 
   property orderType:WideString dispid 6;
    // lmtPrice : property lmtPrice 
   property lmtPrice:Double dispid 7;
    // auxPrice : property auxPrice 
   property auxPrice:Double dispid 8;
    // timeInForce : property timeInForce 
   property timeInForce:WideString dispid 20;
    // activeStartTime : property activeStartTime 
   property activeStartTime:WideString dispid 140;
    // activeStopTime : property activeStopTime 
   property activeStopTime:WideString dispid 141;
    // ocaGroup : property ocaGroup 
   property ocaGroup:WideString dispid 21;
    // ocaType : property ocaType 
   property ocaType:Integer dispid 22;
    // orderRef : property orderRef 
   property orderRef:WideString dispid 23;
    // transmit : property transmit 
   property transmit:Integer dispid 24;
    // parentId : property parentId 
   property parentId:Integer dispid 25;
    // blockOrder : property blockOrder 
   property blockOrder:Integer dispid 26;
    // sweepToFill : property sweepToFill 
   property sweepToFill:Integer dispid 27;
    // displaySize : property displaySize 
   property displaySize:Integer dispid 28;
    // triggerMethod : property triggerMethod 
   property triggerMethod:Integer dispid 29;
    // outsideRth : property outsideRth 
   property outsideRth:Integer dispid 30;
    // hidden : property hidden 
   property hidden:Integer dispid 31;
    // goodAfterTime : property goodAfterTime 
   property goodAfterTime:WideString dispid 32;
    // goodTillDate : property goodTillDate 
   property goodTillDate:WideString dispid 33;
    // overridePercentageConstraints : property overridePercentageConstraints 
   property overridePercentageConstraints:Integer dispid 35;
    // rule80A : property rule80A 
   property rule80A:WideString dispid 36;
    // allOrNone : property allOrNone 
   property allOrNone:Integer dispid 37;
    // minQty : property minQty 
   property minQty:Integer dispid 38;
    // percentOffset : property percentOffset 
   property percentOffset:Double dispid 39;
    // trailStopPrice : property trailStopPrice 
   property trailStopPrice:Double dispid 40;
    // trailingPercent : property trailingPercent 
   property trailingPercent:Double dispid 44;
    // whatIf : property whatIf 
   property whatIf:Integer dispid 41;
    // notHeld : property notHeld 
   property notHeld:Integer dispid 42;
    // faGroup : property faGroup 
   property faGroup:WideString dispid 60;
    // faProfile : property faProfile 
   property faProfile:WideString dispid 61;
    // faMethod : property faMethod 
   property faMethod:WideString dispid 62;
    // faPercentage : property faPercentage 
   property faPercentage:WideString dispid 63;
    // openClose : property openClose 
   property openClose:WideString dispid 72;
    // origin : property origin 
   property origin:Integer dispid 73;
    // shortSaleSlot : property shortSaleSlot 
   property shortSaleSlot:Integer dispid 74;
    // designatedLocation : property designatedLocation 
   property designatedLocation:WideString dispid 75;
    // exemptCode : property exemptCode 
   property exemptCode:Integer dispid 76;
    // discretionaryAmt : property discretionaryAmt 
   property discretionaryAmt:Double dispid 80;
    // eTradeOnly : property eTradeOnly 
   property eTradeOnly:Integer dispid 81;
    // firmQuoteOnly : property firmQuoteOnly 
   property firmQuoteOnly:Integer dispid 82;
    // nbboPriceCap : property nbboPriceCap 
   property nbboPriceCap:Double dispid 83;
    // optOutSmartRouting : property optOutSmartRouting 
   property optOutSmartRouting:Integer dispid 84;
    // auctionStrategy : property auctionStrategy 
   property auctionStrategy:Integer dispid 90;
    // startingPrice : property startingPrice 
   property startingPrice:Double dispid 91;
    // stockRefPrice : property stockRefPrice 
   property stockRefPrice:Double dispid 92;
    // delta : property delta 
   property delta:Double dispid 93;
    // stockRangeLower : property stockRangeLower 
   property stockRangeLower:Double dispid 94;
    // stockRangeUpper : property stockRangeUpper 
   property stockRangeUpper:Double dispid 95;
    // volatility : property volatility 
   property volatility:Double dispid 96;
    // volatilityType : property volatilityType 
   property volatilityType:Integer dispid 97;
    // continuousUpdate : property continuousUpdate 
   property continuousUpdate:Integer dispid 98;
    // referencePriceType : property referencePriceType 
   property referencePriceType:Integer dispid 99;
    // deltaNeutralOrderType : property deltaNeutralOrderType 
   property deltaNeutralOrderType:WideString dispid 100;
    // deltaNeutralAuxPrice : property deltaNeutralAuxPrice 
   property deltaNeutralAuxPrice:Double dispid 101;
    // deltaNeutralConId : property deltaNeutralConId 
   property deltaNeutralConId:Integer dispid 123;
    // deltaNeutralSettlingFirm : property deltaNeutralSettlingFirm 
   property deltaNeutralSettlingFirm:WideString dispid 124;
    // deltaNeutralClearingAccount : property deltaNeutralClearingAccount 
   property deltaNeutralClearingAccount:WideString dispid 125;
    // deltaNeutralClearingIntent : property deltaNeutralClearingIntent 
   property deltaNeutralClearingIntent:WideString dispid 126;
    // deltaNeutralOpenClose : property deltaNeutralOpenClose 
   property deltaNeutralOpenClose:WideString dispid 135;
    // deltaNeutralShortSale : property deltaNeutralShortSale 
   property deltaNeutralShortSale:Integer dispid 136;
    // deltaNeutralShortSaleSlot : property deltaNeutralShortSaleSlot 
   property deltaNeutralShortSaleSlot:Integer dispid 137;
    // deltaNeutralDesignatedLocation : property deltaNeutralDesignatedLocation 
   property deltaNeutralDesignatedLocation:WideString dispid 138;
    // basisPoints : property basisPoints 
   property basisPoints:Double dispid 102;
    // basisPointsType : property basisPointsType 
   property basisPointsType:Integer dispid 103;
    // scaleInitLevelSize : property scaleInitLevelSize 
   property scaleInitLevelSize:Integer dispid 104;
    // scaleSubsLevelSize : property scaleSubsLevelSize 
   property scaleSubsLevelSize:Integer dispid 105;
    // scalePriceIncrement : property scalePriceIncrement 
   property scalePriceIncrement:Double dispid 106;
    // scalePriceAdjustValue : property scalePriceAdjustValue 
   property scalePriceAdjustValue:Double dispid 127;
    // scalePriceAdjustInterval : property scalePriceAdjustInterval 
   property scalePriceAdjustInterval:Integer dispid 128;
    // scaleProfitOffset : property scaleProfitOffset 
   property scaleProfitOffset:Double dispid 129;
    // scaleAutoReset : property scaleAutoReset 
   property scaleAutoReset:Integer dispid 130;
    // scaleInitPosition : property scaleInitPosition 
   property scaleInitPosition:Integer dispid 131;
    // scaleInitFillQty : property scaleInitFillQty 
   property scaleInitFillQty:Integer dispid 132;
    // scaleRandomPercent : property scaleRandomPercent 
   property scaleRandomPercent:Integer dispid 133;
    // scaleTable : property scaleTable 
   property scaleTable:WideString dispid 139;
    // hedgeType : property hedgeType 
   property hedgeType:WideString dispid 107;
    // hedgeParam : property hedgeParam 
   property hedgeParam:WideString dispid 108;
    // account : property account 
   property account:WideString dispid 110;
    // settlingFirm : property settlingFirm 
   property settlingFirm:WideString dispid 111;
    // clearingAccount : property clearingAccount 
   property clearingAccount:WideString dispid 112;
    // clearingIntent : property clearingIntent 
   property clearingIntent:WideString dispid 113;
    // algoStrategy : property algoStrategy 
   property algoStrategy:WideString dispid 120;
    // algoParams : property algoParams 
   property algoParams:IDispatch dispid 121;
    // smartComboRoutingParams : property smartComboRoutingParams 
   property smartComboRoutingParams:IDispatch dispid 122;
    // orderComboLegs : property orderComboLegs 
   property orderComboLegs:IDispatch dispid 134;
    // orderMiscOptions : property orderMiscOptions 
   property orderMiscOptions:IDispatch dispid 142;
  end;


// IOrderState : IOrderState Interface

 IOrderState = interface(IDispatch)
   ['{7B33AE1F-99B0-4BCB-A024-42335897A6AF}']
   function Get_status : WideString; safecall;
   function Get_initMargin : WideString; safecall;
   function Get_maintMargin : WideString; safecall;
   function Get_equityWithLoan : WideString; safecall;
   function Get_commission : Double; safecall;
   function Get_minCommission : Double; safecall;
   function Get_maxCommission : Double; safecall;
   function Get_commissionCurrency : WideString; safecall;
   function Get_warningText : WideString; safecall;
    // status : property status 
   property status:WideString read Get_status;
    // initMargin : property initMargin 
   property initMargin:WideString read Get_initMargin;
    // maintMargin : property maintMargin 
   property maintMargin:WideString read Get_maintMargin;
    // equityWithLoan : property equityWithLoan 
   property equityWithLoan:WideString read Get_equityWithLoan;
    // commission : property commission 
   property commission:Double read Get_commission;
    // minCommission : property minCommission 
   property minCommission:Double read Get_minCommission;
    // maxCommission : property maxCommission 
   property maxCommission:Double read Get_maxCommission;
    // commissionCurrency : property commissionCurrency 
   property commissionCurrency:WideString read Get_commissionCurrency;
    // warningText : property warningText 
   property warningText:WideString read Get_warningText;
  end;


// IOrderState : IOrderState Interface

 IOrderStateDisp = dispinterface
   ['{7B33AE1F-99B0-4BCB-A024-42335897A6AF}']
    // status : property status 
   property status:WideString  readonly dispid 1;
    // initMargin : property initMargin 
   property initMargin:WideString  readonly dispid 2;
    // maintMargin : property maintMargin 
   property maintMargin:WideString  readonly dispid 3;
    // equityWithLoan : property equityWithLoan 
   property equityWithLoan:WideString  readonly dispid 4;
    // commission : property commission 
   property commission:Double  readonly dispid 5;
    // minCommission : property minCommission 
   property minCommission:Double  readonly dispid 6;
    // maxCommission : property maxCommission 
   property maxCommission:Double  readonly dispid 7;
    // commissionCurrency : property commissionCurrency 
   property commissionCurrency:WideString  readonly dispid 8;
    // warningText : property warningText 
   property warningText:WideString  readonly dispid 9;
  end;


// IExecution : IExecution Interface

 IExecution = interface(IDispatch)
   ['{58BDEC36-791C-4E2E-88A4-6E4339392B5B}']
   function Get_execId : WideString; safecall;
   function Get_orderId : Integer; safecall;
   function Get_clientId : Integer; safecall;
   function Get_permId : Integer; safecall;
   function Get_time : WideString; safecall;
   function Get_acctNumber : WideString; safecall;
   function Get_exchange : WideString; safecall;
   function Get_side : WideString; safecall;
   function Get_shares : Integer; safecall;
   function Get_price : Double; safecall;
   function Get_liquidation : Integer; safecall;
   function Get_cumQty : Integer; safecall;
   function Get_avgPrice : Double; safecall;
   function Get_orderRef : WideString; safecall;
   function Get_evRule : WideString; safecall;
   function Get_evMultiplier : Double; safecall;
    // execId : property execId 
   property execId:WideString read Get_execId;
    // orderId : property orderId 
   property orderId:Integer read Get_orderId;
    // clientId : property clientId 
   property clientId:Integer read Get_clientId;
    // permId : property permId 
   property permId:Integer read Get_permId;
    // time : property time 
   property time:WideString read Get_time;
    // acctNumber : property acctNumber 
   property acctNumber:WideString read Get_acctNumber;
    // exchange : property exchange 
   property exchange:WideString read Get_exchange;
    // side : property side 
   property side:WideString read Get_side;
    // shares : property shares 
   property shares:Integer read Get_shares;
    // price : property price 
   property price:Double read Get_price;
    // liquidation : property liquidation 
   property liquidation:Integer read Get_liquidation;
    // cumQty : property cumQty 
   property cumQty:Integer read Get_cumQty;
    // avgPrice : property avgPrice 
   property avgPrice:Double read Get_avgPrice;
    // orderRef : property orderRef 
   property orderRef:WideString read Get_orderRef;
    // evRule : property evRule 
   property evRule:WideString read Get_evRule;
    // evMultiplier : property evMultiplier 
   property evMultiplier:Double read Get_evMultiplier;
  end;


// IExecution : IExecution Interface

 IExecutionDisp = dispinterface
   ['{58BDEC36-791C-4E2E-88A4-6E4339392B5B}']
    // execId : property execId 
   property execId:WideString  readonly dispid 1;
    // orderId : property orderId 
   property orderId:Integer  readonly dispid 2;
    // clientId : property clientId 
   property clientId:Integer  readonly dispid 3;
    // permId : property permId 
   property permId:Integer  readonly dispid 4;
    // time : property time 
   property time:WideString  readonly dispid 5;
    // acctNumber : property acctNumber 
   property acctNumber:WideString  readonly dispid 6;
    // exchange : property exchange 
   property exchange:WideString  readonly dispid 7;
    // side : property side 
   property side:WideString  readonly dispid 8;
    // shares : property shares 
   property shares:Integer  readonly dispid 9;
    // price : property price 
   property price:Double  readonly dispid 10;
    // liquidation : property liquidation 
   property liquidation:Integer  readonly dispid 11;
    // cumQty : property cumQty 
   property cumQty:Integer  readonly dispid 12;
    // avgPrice : property avgPrice 
   property avgPrice:Double  readonly dispid 13;
    // orderRef : property orderRef 
   property orderRef:WideString  readonly dispid 14;
    // evRule : property evRule 
   property evRule:WideString  readonly dispid 15;
    // evMultiplier : property evMultiplier 
   property evMultiplier:Double  readonly dispid 16;
  end;


// IExecutionFilter : IExecutionFilter Interface

 IExecutionFilter = interface(IDispatch)
   ['{3553EA07-F281-433D-B2A4-4CB722A9859B}']
   function Get_clientId : Integer; safecall;
   procedure Set_clientId(const pVal:Integer); safecall;
   function Get_acctCode : WideString; safecall;
   procedure Set_acctCode(const pVal:WideString); safecall;
   function Get_time : WideString; safecall;
   procedure Set_time(const pVal:WideString); safecall;
   function Get_symbol : WideString; safecall;
   procedure Set_symbol(const pVal:WideString); safecall;
   function Get_secType : WideString; safecall;
   procedure Set_secType(const pVal:WideString); safecall;
   function Get_exchange : WideString; safecall;
   procedure Set_exchange(const pVal:WideString); safecall;
   function Get_side : WideString; safecall;
   procedure Set_side(const pVal:WideString); safecall;
    // clientId : property clientId 
   property clientId:Integer read Get_clientId write Set_clientId;
    // acctCode : property acctCode 
   property acctCode:WideString read Get_acctCode write Set_acctCode;
    // time : property time 
   property time:WideString read Get_time write Set_time;
    // symbol : property symbol 
   property symbol:WideString read Get_symbol write Set_symbol;
    // secType : property secType 
   property secType:WideString read Get_secType write Set_secType;
    // exchange : property exchange 
   property exchange:WideString read Get_exchange write Set_exchange;
    // side : property side 
   property side:WideString read Get_side write Set_side;
  end;


// IExecutionFilter : IExecutionFilter Interface

 IExecutionFilterDisp = dispinterface
   ['{3553EA07-F281-433D-B2A4-4CB722A9859B}']
    // clientId : property clientId 
   property clientId:Integer dispid 1;
    // acctCode : property acctCode 
   property acctCode:WideString dispid 2;
    // time : property time 
   property time:WideString dispid 3;
    // symbol : property symbol 
   property symbol:WideString dispid 4;
    // secType : property secType 
   property secType:WideString dispid 5;
    // exchange : property exchange 
   property exchange:WideString dispid 6;
    // side : property side 
   property side:WideString dispid 7;
  end;


// IScannerSubscription : IScannerSubscription Interface

 IScannerSubscription = interface(IDispatch)
   ['{6BBE7E50-795D-4C45-A69E-E1EEB7918DD2}']
   function Get_instrument : WideString; safecall;
   procedure Set_instrument(const pVal:WideString); safecall;
   function Get_locations : WideString; safecall;
   procedure Set_locations(const pVal:WideString); safecall;
   function Get_scanCode : WideString; safecall;
   procedure Set_scanCode(const pVal:WideString); safecall;
   function Get_numberOfRows : Integer; safecall;
   procedure Set_numberOfRows(const pVal:Integer); safecall;
   function Get_priceAbove : Double; safecall;
   procedure Set_priceAbove(const pVal:Double); safecall;
   function Get_priceBelow : Double; safecall;
   procedure Set_priceBelow(const pVal:Double); safecall;
   function Get_volumeAbove : Integer; safecall;
   procedure Set_volumeAbove(const pVal:Integer); safecall;
   function Get_averageOptionVolumeAbove : Integer; safecall;
   procedure Set_averageOptionVolumeAbove(const pVal:Integer); safecall;
   function Get_marketCapAbove : Double; safecall;
   procedure Set_marketCapAbove(const pVal:Double); safecall;
   function Get_marketCapBelow : Double; safecall;
   procedure Set_marketCapBelow(const pVal:Double); safecall;
   function Get_moodyRatingAbove : WideString; safecall;
   procedure Set_moodyRatingAbove(const pVal:WideString); safecall;
   function Get_moodyRatingBelow : WideString; safecall;
   procedure Set_moodyRatingBelow(const pVal:WideString); safecall;
   function Get_spRatingAbove : WideString; safecall;
   procedure Set_spRatingAbove(const pVal:WideString); safecall;
   function Get_spRatingBelow : WideString; safecall;
   procedure Set_spRatingBelow(const pVal:WideString); safecall;
   function Get_maturityDateAbove : WideString; safecall;
   procedure Set_maturityDateAbove(const pVal:WideString); safecall;
   function Get_maturityDateBelow : WideString; safecall;
   procedure Set_maturityDateBelow(const pVal:WideString); safecall;
   function Get_couponRateAbove : Double; safecall;
   procedure Set_couponRateAbove(const pVal:Double); safecall;
   function Get_couponRateBelow : Double; safecall;
   procedure Set_couponRateBelow(const pVal:Double); safecall;
   function Get_excludeConvertible : Integer; safecall;
   procedure Set_excludeConvertible(const pVal:Integer); safecall;
   function Get_scannerSettingPairs : WideString; safecall;
   procedure Set_scannerSettingPairs(const pVal:WideString); safecall;
   function Get_stockTypeFilter : WideString; safecall;
   procedure Set_stockTypeFilter(const pVal:WideString); safecall;
    // instrument : property instrument 
   property instrument:WideString read Get_instrument write Set_instrument;
    // locations : property locations 
   property locations:WideString read Get_locations write Set_locations;
    // scanCode : property scanCode 
   property scanCode:WideString read Get_scanCode write Set_scanCode;
    // numberOfRows : property numberOfRows 
   property numberOfRows:Integer read Get_numberOfRows write Set_numberOfRows;
    // priceAbove : property priceAbove 
   property priceAbove:Double read Get_priceAbove write Set_priceAbove;
    // priceBelow : property priceBelow 
   property priceBelow:Double read Get_priceBelow write Set_priceBelow;
    // volumeAbove : property volumeAbove 
   property volumeAbove:Integer read Get_volumeAbove write Set_volumeAbove;
    // averageOptionVolumeAbove : property averageOptionVolumeAbove 
   property averageOptionVolumeAbove:Integer read Get_averageOptionVolumeAbove write Set_averageOptionVolumeAbove;
    // marketCapAbove : property marketCapAbove 
   property marketCapAbove:Double read Get_marketCapAbove write Set_marketCapAbove;
    // marketCapBelow : property marketCapBelow 
   property marketCapBelow:Double read Get_marketCapBelow write Set_marketCapBelow;
    // moodyRatingAbove : property moodyRatingAbove 
   property moodyRatingAbove:WideString read Get_moodyRatingAbove write Set_moodyRatingAbove;
    // moodyRatingBelow : property moodyRatingBelow 
   property moodyRatingBelow:WideString read Get_moodyRatingBelow write Set_moodyRatingBelow;
    // spRatingAbove : property spRatingAbove 
   property spRatingAbove:WideString read Get_spRatingAbove write Set_spRatingAbove;
    // spRatingBelow : property spRatingBelow 
   property spRatingBelow:WideString read Get_spRatingBelow write Set_spRatingBelow;
    // maturityDateAbove : property maturityDateAbove 
   property maturityDateAbove:WideString read Get_maturityDateAbove write Set_maturityDateAbove;
    // maturityDateBelow : property maturityDateBelow 
   property maturityDateBelow:WideString read Get_maturityDateBelow write Set_maturityDateBelow;
    // couponRateAbove : property couponRateAbove 
   property couponRateAbove:Double read Get_couponRateAbove write Set_couponRateAbove;
    // couponRateBelow : property couponRateBelow 
   property couponRateBelow:Double read Get_couponRateBelow write Set_couponRateBelow;
    // excludeConvertible : property excludeConvertible 
   property excludeConvertible:Integer read Get_excludeConvertible write Set_excludeConvertible;
    // scannerSettingPairs : property scannerSettingPairs 
   property scannerSettingPairs:WideString read Get_scannerSettingPairs write Set_scannerSettingPairs;
    // stockTypeFilter : property stockTypeFilter 
   property stockTypeFilter:WideString read Get_stockTypeFilter write Set_stockTypeFilter;
  end;


// IScannerSubscription : IScannerSubscription Interface

 IScannerSubscriptionDisp = dispinterface
   ['{6BBE7E50-795D-4C45-A69E-E1EEB7918DD2}']
    // instrument : property instrument 
   property instrument:WideString dispid 1;
    // locations : property locations 
   property locations:WideString dispid 2;
    // scanCode : property scanCode 
   property scanCode:WideString dispid 3;
    // numberOfRows : property numberOfRows 
   property numberOfRows:Integer dispid 4;
    // priceAbove : property priceAbove 
   property priceAbove:Double dispid 100;
    // priceBelow : property priceBelow 
   property priceBelow:Double dispid 101;
    // volumeAbove : property volumeAbove 
   property volumeAbove:Integer dispid 102;
    // averageOptionVolumeAbove : property averageOptionVolumeAbove 
   property averageOptionVolumeAbove:Integer dispid 103;
    // marketCapAbove : property marketCapAbove 
   property marketCapAbove:Double dispid 104;
    // marketCapBelow : property marketCapBelow 
   property marketCapBelow:Double dispid 105;
    // moodyRatingAbove : property moodyRatingAbove 
   property moodyRatingAbove:WideString dispid 106;
    // moodyRatingBelow : property moodyRatingBelow 
   property moodyRatingBelow:WideString dispid 107;
    // spRatingAbove : property spRatingAbove 
   property spRatingAbove:WideString dispid 108;
    // spRatingBelow : property spRatingBelow 
   property spRatingBelow:WideString dispid 109;
    // maturityDateAbove : property maturityDateAbove 
   property maturityDateAbove:WideString dispid 110;
    // maturityDateBelow : property maturityDateBelow 
   property maturityDateBelow:WideString dispid 111;
    // couponRateAbove : property couponRateAbove 
   property couponRateAbove:Double dispid 112;
    // couponRateBelow : property couponRateBelow 
   property couponRateBelow:Double dispid 113;
    // excludeConvertible : property excludeConvertible 
   property excludeConvertible:Integer dispid 114;
    // scannerSettingPairs : property scannerSettingPairs 
   property scannerSettingPairs:WideString dispid 115;
    // stockTypeFilter : property stockTypeFilter 
   property stockTypeFilter:WideString dispid 116;
  end;


// IOrderComboLeg : IOrderComboLeg Interface

 IOrderComboLeg = interface(IDispatch)
   ['{639C4479-D0B6-49A3-B524-AEA6A9574945}']
   function Get_price : Double; safecall;
   procedure Set_price(const pVal:Double); safecall;
    // price : property price 
   property price:Double read Get_price write Set_price;
  end;


// IOrderComboLeg : IOrderComboLeg Interface

 IOrderComboLegDisp = dispinterface
   ['{639C4479-D0B6-49A3-B524-AEA6A9574945}']
    // price : property price 
   property price:Double dispid 1;
  end;


// IOrderComboLegList : IOrderComboLegList Interface

 IOrderComboLegList = interface(IDispatch)
   ['{39F18DDF-687D-421D-8BB9-4F389D69E428}']
   function Get__NewEnum : IUnknown; safecall;
   function Get_Item(index:Integer) : IDispatch; safecall;
   function Get_Count : Integer; safecall;
    // Add :  
   function Add:IDispatch;safecall;
    // _NewEnum :  
   property _NewEnum:IUnknown read Get__NewEnum;
    // Item :  
   property Item[index:Integer]:IDispatch read Get_Item; default;
    // Count :  
   property Count:Integer read Get_Count;
  end;


// IOrderComboLegList : IOrderComboLegList Interface

 IOrderComboLegListDisp = dispinterface
   ['{39F18DDF-687D-421D-8BB9-4F389D69E428}']
    // Add :  
   function Add:IDispatch;dispid 2;
    // _NewEnum :  
   property _NewEnum:IUnknown  readonly dispid -4;
    // Item :  
   property Item[index:Integer]:IDispatch  readonly dispid 0; default;
    // Count :  
   property Count:Integer  readonly dispid 1;
  end;


// ICommissionReport : ICommissionReport Interface

 ICommissionReport = interface(IDispatch)
   ['{51AE469F-D859-4537-A0BA-A93992F395BB}']
   function Get_execId : WideString; safecall;
   function Get_commission : Double; safecall;
   function Get_currency : WideString; safecall;
   function Get_realizedPNL : Double; safecall;
   function Get_yield : Double; safecall;
   function Get_yieldRedemptionDate : Integer; safecall;
    // execId : property execId 
   property execId:WideString read Get_execId;
    // commission : property commission 
   property commission:Double read Get_commission;
    // currency : property currency 
   property currency:WideString read Get_currency;
    // realizedPNL : property realizedPNL 
   property realizedPNL:Double read Get_realizedPNL;
    // yield : property yield 
   property yield:Double read Get_yield;
    // yieldRedemptionDate : property yieldRedemptionDate 
   property yieldRedemptionDate:Integer read Get_yieldRedemptionDate;
  end;


// ICommissionReport : ICommissionReport Interface

 ICommissionReportDisp = dispinterface
   ['{51AE469F-D859-4537-A0BA-A93992F395BB}']
    // execId : property execId 
   property execId:WideString  readonly dispid 1;
    // commission : property commission 
   property commission:Double  readonly dispid 2;
    // currency : property currency 
   property currency:WideString  readonly dispid 3;
    // realizedPNL : property realizedPNL 
   property realizedPNL:Double  readonly dispid 4;
    // yield : property yield 
   property yield:Double  readonly dispid 5;
    // yieldRedemptionDate : property yieldRedemptionDate 
   property yieldRedemptionDate:Integer  readonly dispid 6;
  end;


// _DTws : Dispatch interface for Tws Control

 _DTws = dispinterface
   ['{0A77CCF6-052C-11D6-B0EC-00B0D074179C}']
    // cancelMktData :  
   procedure cancelMktData(id:Integer);dispid 55;
    // cancelOrder :  
   procedure cancelOrder(id:Integer);dispid 56;
    // placeOrder :  
   procedure placeOrder(id:Integer;action:WideString;quantity:Integer;symbol:WideString;secType:WideString;expiry:WideString;strike:Double;right:WideString;multiplier:WideString;exchange:WideString;primaryExchange:WideString;curency:WideString;orderType:WideString;price:Double;auxPrice:Double;goodAfterTime:WideString;group:WideString;faMethod:WideString;faPercentage:WideString;faProfile:WideString;goodTillDate:WideString);dispid 57;
    // disconnect :  
   procedure disconnect;dispid 58;
    // connect :  
   procedure connect(host:WideString;port:Integer;clientId:Integer;extraAuth:Integer);dispid 59;
    // reqMktData :  
   procedure reqMktData(id:Integer;symbol:WideString;secType:WideString;expiry:WideString;strike:Double;right:WideString;multiplier:WideString;exchange:WideString;primaryExchange:WideString;currency:WideString;genericTicks:WideString;snapshot:Integer);dispid 60;
    // reqOpenOrders :  
   procedure reqOpenOrders;dispid 61;
    // reqAccountUpdates :  
   procedure reqAccountUpdates(subscribe:Integer;acctCode:WideString);dispid 62;
    // reqExecutions :  
   procedure reqExecutions;dispid 63;
    // reqIds :  
   procedure reqIds(numIds:Integer);dispid 64;
    // reqMktData2 :  
   procedure reqMktData2(id:Integer;localSymbol:WideString;secType:WideString;exchange:WideString;primaryExchange:WideString;currency:WideString;genericTicks:WideString;snapshot:Integer);dispid 65;
    // placeOrder2 :  
   procedure placeOrder2(id:Integer;action:WideString;quantity:Integer;localSymbol:WideString;secType:WideString;exchange:WideString;primaryExchange:WideString;curency:WideString;orderType:WideString;lmtPrice:Double;auxPrice:Double;goodAfterTime:WideString;group:WideString;faMethod:WideString;faPercentage:WideString;faProfile:WideString;goodTillDate:WideString);dispid 66;
    // reqContractDetails :  
   procedure reqContractDetails(symbol:WideString;secType:WideString;expiry:WideString;strike:Double;right:WideString;multiplier:WideString;exchange:WideString;curency:WideString;includeExpired:Integer);dispid 67;
    // reqContractDetails2 :  
   procedure reqContractDetails2(localSymbol:WideString;secType:WideString;exchange:WideString;curency:WideString;includeExpired:Integer);dispid 68;
    // reqMktDepth :  
   procedure reqMktDepth(id:Integer;symbol:WideString;secType:WideString;expiry:WideString;strike:Double;right:WideString;multiplier:WideString;exchange:WideString;curency:WideString;numRows:Integer);dispid 69;
    // reqMktDepth2 :  
   procedure reqMktDepth2(id:Integer;localSymbol:WideString;secType:WideString;exchange:WideString;curency:WideString;numRows:Integer);dispid 70;
    // cancelMktDepth :  
   procedure cancelMktDepth(id:Integer);dispid 71;
    // addComboLeg :  
   procedure addComboLeg(conId:Integer;action:WideString;ratio:Integer;exchange:WideString;openClose:Integer;shortSaleSlot:Integer;designatedLocation:WideString;exemptCode:Integer);dispid 72;
    // clearComboLegs :  
   procedure clearComboLegs;dispid 73;
    // cancelNewsBulletins :  
   procedure cancelNewsBulletins;dispid 74;
    // reqNewsBulletins :  
   procedure reqNewsBulletins(allDaysMsgs:Integer);dispid 75;
    // setServerLogLevel :  
   procedure setServerLogLevel(logLevel:Integer);dispid 76;
    // reqAutoOpenOrders :  
   procedure reqAutoOpenOrders(bAutoBind:Integer);dispid 77;
    // reqAllOpenOrders :  
   procedure reqAllOpenOrders;dispid 78;
    // reqManagedAccts :  
   procedure reqManagedAccts;dispid 79;
    // requestFA :  
   procedure requestFA(faDataType:Integer);dispid 80;
    // replaceFA :  
   procedure replaceFA(faDataType:Integer;cxml:WideString);dispid 81;
    // reqHistoricalData :  
   procedure reqHistoricalData(id:Integer;symbol:WideString;secType:WideString;expiry:WideString;strike:Double;right:WideString;multiplier:WideString;exchange:WideString;curency:WideString;isExpired:Integer;endDateTime:WideString;durationStr:WideString;barSizeSetting:WideString;whatToShow:WideString;useRTH:Integer;formatDate:Integer);dispid 82;
    // exerciseOptions :  
   procedure exerciseOptions(id:Integer;symbol:WideString;secType:WideString;expiry:WideString;strike:Double;right:WideString;multiplier:WideString;exchange:WideString;curency:WideString;exerciseAction:Integer;exerciseQuantity:Integer;override:Integer);dispid 83;
    // reqScannerParameters :  
   procedure reqScannerParameters;dispid 84;
    // reqScannerSubscription :  
   procedure reqScannerSubscription(tickerId:Integer;numberOfRows:Integer;instrument:WideString;locationCode:WideString;scanCode:WideString;abovePrice:Double;belowPrice:Double;aboveVolume:Integer;marketCapAbove:Double;marketCapBelow:Double;moodyRatingAbove:WideString;moodyRatingBelow:WideString;spRatingAbove:WideString;spRatingBelow:WideString;maturityDateAbove:WideString;maturityDateBelow:WideString;couponRateAbove:Double;couponRateBelow:Double;excludeConvertible:Integer;averageOptionVolumeAbove:Integer;scannerSettingPairs:WideString;stockTypeFilter:WideString);dispid 85;
    // cancelHistoricalData :  
   procedure cancelHistoricalData(tickerId:Integer);dispid 86;
    // cancelScannerSubscription :  
   procedure cancelScannerSubscription(tickerId:Integer);dispid 87;
    // resetAllProperties :  
   procedure resetAllProperties;dispid 88;
    // reqRealTimeBars :  
   procedure reqRealTimeBars(tickerId:Integer;symbol:WideString;secType:WideString;expiry:WideString;strike:Double;right:WideString;multiplier:WideString;exchange:WideString;primaryExchange:WideString;currency:WideString;isExpired:Integer;barSize:Integer;whatToShow:WideString;useRTH:Integer);dispid 89;
    // cancelRealTimeBars :  
   procedure cancelRealTimeBars(tickerId:Integer);dispid 90;
    // reqCurrentTime :  
   procedure reqCurrentTime;dispid 91;
    // reqFundamentalData :  
   procedure reqFundamentalData(reqId:Integer;contract:IContract;reportType:WideString);dispid 92;
    // cancelFundamentalData :  
   procedure cancelFundamentalData(reqId:Integer);dispid 93;
    // calculateImpliedVolatility :  
   procedure calculateImpliedVolatility(reqId:Integer;contract:IContract;optionPrice:Double;underPrice:Double);dispid 94;
    // calculateOptionPrice :  
   procedure calculateOptionPrice(reqId:Integer;contract:IContract;volatility:Double;underPrice:Double);dispid 95;
    // cancelCalculateImpliedVolatility :  
   procedure cancelCalculateImpliedVolatility(reqId:Integer);dispid 96;
    // cancelCalculateOptionPrice :  
   procedure cancelCalculateOptionPrice(reqId:Integer);dispid 97;
    // reqGlobalCancel :  
   procedure reqGlobalCancel;dispid 98;
    // reqMarketDataType :  
   procedure reqMarketDataType(marketDataType:Integer);dispid 99;
    // reqContractDetailsEx :  
   procedure reqContractDetailsEx(reqId:Integer;contract:IContract);dispid 100;
    // reqMktDataEx :  
   procedure reqMktDataEx(tickerId:Integer;contract:IContract;genericTicks:WideString;snapshot:Integer;mktDataOptions:ITagValueList);dispid 101;
    // reqMktDepthEx :  
   procedure reqMktDepthEx(tickerId:Integer;contract:IContract;numRows:Integer;mktDepthOptions:ITagValueList);dispid 102;
    // placeOrderEx :  
   procedure placeOrderEx(orderId:Integer;contract:IContract;order:IOrder);dispid 103;
    // reqExecutionsEx :  
   procedure reqExecutionsEx(reqId:Integer;filter:IExecutionFilter);dispid 104;
    // exerciseOptionsEx :  
   procedure exerciseOptionsEx(tickerId:Integer;contract:IContract;exerciseAction:Integer;exerciseQuantity:Integer;account:WideString;override:Integer);dispid 105;
    // reqHistoricalDataEx :  
   procedure reqHistoricalDataEx(tickerId:Integer;contract:IContract;endDateTime:WideString;duration:WideString;barSize:WideString;whatToShow:WideString;useRTH:Integer;formatDate:Integer;chartOptions:ITagValueList);dispid 106;
    // reqRealTimeBarsEx :  
   procedure reqRealTimeBarsEx(tickerId:Integer;contract:IContract;barSize:Integer;whatToShow:WideString;useRTH:Integer;realTimeBarsOptions:ITagValueList);dispid 107;
    // reqScannerSubscriptionEx :  
   procedure reqScannerSubscriptionEx(tickerId:Integer;subscription:IScannerSubscription;scannerSubscriptionOptions:ITagValueList);dispid 108;
    // addOrderComboLeg :  
   procedure addOrderComboLeg(price:Double);dispid 109;
    // clearOrderComboLegs :  
   procedure clearOrderComboLegs;dispid 110;
    // reqPositions :  
   procedure reqPositions;dispid 111;
    // cancelPositions :  
   procedure cancelPositions;dispid 112;
    // reqAccountSummary :  
   procedure reqAccountSummary(reqId:Integer;groupName:WideString;tags:WideString);dispid 113;
    // cancelAccountSummary :  
   procedure cancelAccountSummary(reqId:Integer);dispid 114;
    // verifyRequest :  
   procedure verifyRequest(apiName:WideString;apiVersion:WideString);dispid 115;
    // verifyMessage :  
   procedure verifyMessage(apiData:WideString);dispid 116;
    // queryDisplayGroups :  
   procedure queryDisplayGroups(reqId:Integer);dispid 117;
    // subscribeToGroupEvents :  
   procedure subscribeToGroupEvents(reqId:Integer;groupId:Integer);dispid 118;
    // updateDisplayGroup :  
   procedure updateDisplayGroup(reqId:Integer;contractInfo:WideString);dispid 119;
    // unsubscribeFromGroupEvents :  
   procedure unsubscribeFromGroupEvents(reqId:Integer);dispid 120;
    // createContract :  
   function createContract:IContract;dispid 200;
    // createComboLegList :  
   function createComboLegList:IComboLegList;dispid 201;
    // createOrder :  
   function createOrder:IOrder;dispid 202;
    // createExecutionFilter :  
   function createExecutionFilter:IExecutionFilter;dispid 203;
    // createScannerSubscription :  
   function createScannerSubscription:IScannerSubscription;dispid 204;
    // createUnderComp :  
   function createUnderComp:IUnderComp;dispid 205;
    // createTagValueList :  
   function createTagValueList:ITagValueList;dispid 206;
    // createOrderComboLegList :  
   function createOrderComboLegList:IOrderComboLegList;dispid 207;
    // account :  
   property account:WideString  dispid 1;
    // tif :  
   property tif:WideString  dispid 2;
    // oca :  
   property oca:WideString  dispid 3;
    // orderRef :  
   property orderRef:WideString  dispid 4;
    // origin :  
   property origin:Integer  dispid 5;
    // transmit :  
   property transmit:Integer  dispid 6;
    // openClose :  
   property openClose:WideString  dispid 7;
    // parentId :  
   property parentId:Integer  dispid 8;
    // blockOrder :  
   property blockOrder:Integer  dispid 9;
    // sweepToFill :  
   property sweepToFill:Integer  dispid 10;
    // displaySize :  
   property displaySize:Integer  dispid 11;
    // triggerMethod :  
   property triggerMethod:Integer  dispid 12;
    // outsideRth :  
   property outsideRth:Integer  dispid 13;
    // hidden :  
   property hidden:Integer  dispid 14;
    // clientIdFilter :  
   property clientIdFilter:Integer  dispid 16;
    // acctCodeFilter :  
   property acctCodeFilter:WideString  dispid 17;
    // timeFilter :  
   property timeFilter:WideString  dispid 18;
    // symbolFilter :  
   property symbolFilter:WideString  dispid 19;
    // secTypeFilter :  
   property secTypeFilter:WideString  dispid 20;
    // exchangeFilter :  
   property exchangeFilter:WideString  dispid 21;
    // sideFilter :  
   property sideFilter:WideString  dispid 22;
    // discretionaryAmt :  
   property discretionaryAmt:Double  dispid 23;
    // shortSaleSlot :  
   property shortSaleSlot:Integer  dispid 24;
    // designatedLocation :  
   property designatedLocation:WideString  dispid 25;
    // ocaType :  
   property ocaType:Integer  dispid 26;
    // exemptCode :  
   property exemptCode:Integer  dispid 27;
    // rule80A :  
   property rule80A:WideString  dispid 28;
    // settlingFirm :  
   property settlingFirm:WideString  dispid 29;
    // allOrNone :  
   property allOrNone:Integer  dispid 30;
    // minQty :  
   property minQty:Integer  dispid 31;
    // percentOffset :  
   property percentOffset:Double  dispid 32;
    // eTradeOnly :  
   property eTradeOnly:Integer  dispid 33;
    // firmQuoteOnly :  
   property firmQuoteOnly:Integer  dispid 34;
    // nbboPriceCap :  
   property nbboPriceCap:Double  dispid 35;
    // auctionStrategy :  
   property auctionStrategy:Integer  dispid 36;
    // startingPrice :  
   property startingPrice:Double  dispid 37;
    // stockRefPrice :  
   property stockRefPrice:Double  dispid 38;
    // delta :  
   property delta:Double  dispid 39;
    // stockRangeLower :  
   property stockRangeLower:Double  dispid 40;
    // stockRangeUpper :  
   property stockRangeUpper:Double  dispid 41;
    // TwsConnectionTime :  
   property TwsConnectionTime:WideString  dispid 42;
    // serverVersion :  
   property serverVersion:Integer  dispid 43;
    // overridePercentageConstraints :  
   property overridePercentageConstraints:Integer  dispid 44;
    // volatility :  
   property volatility:Double  dispid 45;
    // volatilityType :  
   property volatilityType:Integer  dispid 46;
    // deltaNeutralOrderType :  
   property deltaNeutralOrderType:WideString  dispid 47;
    // deltaNeutralAuxPrice :  
   property deltaNeutralAuxPrice:Double  dispid 48;
    // continuousUpdate :  
   property continuousUpdate:Integer  dispid 49;
    // referencePriceType :  
   property referencePriceType:Integer  dispid 50;
    // trailStopPrice :  
   property trailStopPrice:Double  dispid 51;
    // scaleInitLevelSize :  
   property scaleInitLevelSize:Integer  dispid 52;
    // scaleSubsLevelSize :  
   property scaleSubsLevelSize:Integer  dispid 53;
    // scalePriceIncrement :  
   property scalePriceIncrement:Double  dispid 54;
  end;


// _DTwsEvents : Event interface for Tws Control

 _DTwsEvents = dispinterface
   ['{0A77CCF7-052C-11D6-B0EC-00B0D074179C}']
    // tickPrice :  
   procedure tickPrice(id:Integer;tickType:Integer;price:Double;canAutoExecute:SYSINT);dispid 1;
    // tickSize :  
   procedure tickSize(id:Integer;tickType:Integer;size:Integer);dispid 2;
    // connectionClosed :  
   procedure connectionClosed;dispid 3;
    // openOrder1 :  
   procedure openOrder1(id:Integer;symbol:WideString;secType:WideString;expiry:WideString;strike:Double;right:WideString;exchange:WideString;curency:WideString;localSymbol:WideString);dispid 4;
    // openOrder2 :  
   procedure openOrder2(id:Integer;action:WideString;quantity:Integer;orderType:WideString;lmtPrice:Double;auxPrice:Double;tif:WideString;ocaGroup:WideString;account:WideString;openClose:WideString;origin:Integer;orderRef:WideString;clientId:Integer);dispid 5;
    // updateAccountTime :  
   procedure updateAccountTime(timeStamp:WideString);dispid 6;
    // updateAccountValue :  
   procedure updateAccountValue(key:WideString;value:WideString;curency:WideString;accountName:WideString);dispid 7;
    // nextValidId :  
   procedure nextValidId(id:Integer);dispid 8;
    // permId :  
   procedure permId(id:Integer;permId:Integer);dispid 10;
    // errMsg :  
   procedure errMsg(id:Integer;errorCode:Integer;errorMsg:WideString);dispid 11;
    // updatePortfolio :  
   procedure updatePortfolio(symbol:WideString;secType:WideString;expiry:WideString;strike:Double;right:WideString;curency:WideString;localSymbol:WideString;position:Integer;marketPrice:Double;marketValue:Double;averageCost:Double;unrealizedPNL:Double;realizedPNL:Double;accountName:WideString);dispid 12;
    // orderStatus :  
   procedure orderStatus(id:Integer;status:WideString;filled:Integer;remaining:Integer;avgFillPrice:Double;permId:Integer;parentId:Integer;lastFillPrice:Double;clientId:Integer;whyHeld:WideString);dispid 13;
    // contractDetails :  
   procedure contractDetails(symbol:WideString;secType:WideString;expiry:WideString;strike:Double;right:WideString;exchange:WideString;curency:WideString;localSymbol:WideString;marketName:WideString;tradingClass:WideString;conId:Integer;minTick:Double;priceMagnifier:Integer;multiplier:WideString;orderTypes:WideString;validExchanges:WideString);dispid 14;
    // execDetails :  
   procedure execDetails(id:Integer;symbol:WideString;secType:WideString;expiry:WideString;strike:Double;right:WideString;cExchange:WideString;curency:WideString;localSymbol:WideString;execId:WideString;time:WideString;acctNumber:WideString;eExchange:WideString;side:WideString;shares:Integer;price:Double;permId:Integer;clientId:Integer;isLiquidation:SYSINT);dispid 15;
    // updateMktDepth :  
   procedure updateMktDepth(id:Integer;position:Integer;operation:Integer;side:Integer;price:Double;size:Integer);dispid 16;
    // updateMktDepthL2 :  
   procedure updateMktDepthL2(id:Integer;position:Integer;marketMaker:WideString;operation:Integer;side:Integer;price:Double;size:Integer);dispid 17;
    // updateNewsBulletin :  
   procedure updateNewsBulletin(msgId:Smallint;msgType:Smallint;message:WideString;origExchange:WideString);dispid 18;
    // managedAccounts :  
   procedure managedAccounts(accountsList:WideString);dispid 19;
    // openOrder3 :  
   procedure openOrder3(id:Integer;symbol:WideString;secType:WideString;expiry:WideString;strike:Double;right:WideString;exchange:WideString;curency:WideString;localSymbol:WideString;action:WideString;quantity:Integer;orderType:WideString;lmtPrice:Double;auxPrice:Double;tif:WideString;ocaGroup:WideString;account:WideString;openClose:WideString;origin:Integer;orderRef:WideString;clientId:Integer;permId:Integer;sharesAllocation:WideString;faGroup:WideString;faMethod:WideString;faPercentage:WideString;faProfile:WideString;goodAfterTime:WideString;goodTillDate:WideString);dispid 20;
    // receiveFA :  
   procedure receiveFA(faDataType:Integer;cxml:WideString);dispid 21;
    // historicalData :  
   procedure historicalData(reqId:Integer;date:WideString;open:Double;high:Double;low:Double;close:Double;volume:Integer;barCount:Integer;WAP:Double;hasGaps:Integer);dispid 22;
    // openOrder4 :  
   procedure openOrder4(id:Integer;symbol:WideString;secType:WideString;expiry:WideString;strike:Double;right:WideString;exchange:WideString;curency:WideString;localSymbol:WideString;action:WideString;quantity:Integer;orderType:WideString;lmtPrice:Double;auxPrice:Double;tif:WideString;ocaGroup:WideString;account:WideString;openClose:WideString;origin:Integer;orderRef:WideString;clientId:Integer;permId:Integer;sharesAllocation:WideString;faGroup:WideString;faMethod:WideString;faPercentage:WideString;faProfile:WideString;goodAfterTime:WideString;goodTillDate:WideString;ocaType:Integer;rule80A:WideString;settlingFirm:WideString;allOrNone:SYSINT;minQty:Integer;percentOffset:Double;eTradeOnly:SYSINT;firmQuoteOnly:SYSINT;nbboPriceCap:Double;auctionStrategy:Integer;startingPrice:Double;stockRefPrice:Double;delta:Double;stockRangeLower:Double;stockRangeUpper:Double;blockOrder:SYSINT;sweepToFill:SYSINT;ignoreRth:SYSINT;hidden:SYSINT;discretionaryAmt:Double;displaySize:Integer;parentId:Integer;triggerMethod:Integer;shortSaleSlot:Integer;designatedLocation:WideString;volatility:Double;volatilityType:Integer;deltaNeutralOrderType:WideString;deltaNeutralAuxPrice:Double;continuousUpdate:SYSINT;referencePriceType:SYSINT;trailStopPrice:Double;basisPoints:Double;basisPointsType:Integer;legsStr:WideString;scaleInitLevelSize:Integer;scaleSubsLevelSize:Integer;scalePriceIncrement:Double);dispid 23;
    // bondContractDetails :  
   procedure bondContractDetails(symbol:WideString;secType:WideString;cusip:WideString;coupon:Double;maturity:WideString;issueDate:WideString;ratings:WideString;bondType:WideString;couponType:WideString;convertible:Integer;callable:Integer;putable:Integer;descAppend:WideString;exchange:WideString;curency:WideString;marketName:WideString;tradingClass:WideString;conId:Integer;minTick:Double;orderTypes:WideString;validExchanges:WideString;nextOptionDate:WideString;nextOptionType:WideString;nextOptionPartial:Integer;notes:WideString);dispid 24;
    // scannerParameters :  
   procedure scannerParameters(xml:WideString);dispid 25;
    // scannerData :  
   procedure scannerData(reqId:Integer;rank:Integer;symbol:WideString;secType:WideString;expiry:WideString;strike:Double;right:WideString;exchange:WideString;curency:WideString;localSymbol:WideString;marketName:WideString;tradingClass:WideString;distance:WideString;benchmark:WideString;projection:WideString;legsStr:WideString);dispid 26;
    // tickOptionComputation :  
   procedure tickOptionComputation(id:Integer;tickType:Integer;impliedVol:Double;delta:Double;optPrice:Double;pvDividend:Double;gamma:Double;vega:Double;theta:Double;undPrice:Double);dispid 27;
    // tickGeneric :  
   procedure tickGeneric(id:Integer;tickType:Integer;value:Double);dispid 28;
    // tickString :  
   procedure tickString(id:Integer;tickType:Integer;value:WideString);dispid 29;
    // tickEFP :  
   procedure tickEFP(tickerId:Integer;field:Integer;basisPoints:Double;formattedBasisPoints:WideString;totalDividends:Double;holdDays:Integer;futureExpiry:WideString;dividendImpact:Double;dividendsToExpiry:Double);dispid 30;
    // realtimeBar :  
   procedure realtimeBar(tickerId:Integer;time:Integer;open:Double;high:Double;low:Double;close:Double;volume:Integer;WAP:Double;Count:Integer);dispid 31;
    // currentTime :  
   procedure currentTime(time:Integer);dispid 32;
    // scannerDataEnd :  
   procedure scannerDataEnd(reqId:Integer);dispid 33;
    // fundamentalData :  
   procedure fundamentalData(reqId:Integer;data:WideString);dispid 34;
    // contractDetailsEnd :  
   procedure contractDetailsEnd(reqId:Integer);dispid 35;
    // openOrderEnd :  
   procedure openOrderEnd;dispid 36;
    // accountDownloadEnd :  
   procedure accountDownloadEnd(accountName:WideString);dispid 37;
    // execDetailsEnd :  
   procedure execDetailsEnd(reqId:Integer);dispid 38;
    // deltaNeutralValidation :  
   procedure deltaNeutralValidation(reqId:Integer;underComp:IUnderComp);dispid 39;
    // tickSnapshotEnd :  
   procedure tickSnapshotEnd(reqId:Integer);dispid 40;
    // marketDataType :  
   procedure marketDataType(reqId:Integer;marketDataType:Integer);dispid 41;
    // contractDetailsEx :  
   procedure contractDetailsEx(reqId:Integer;contractDetails:IContractDetails);dispid 100;
    // openOrderEx :  
   procedure openOrderEx(orderId:Integer;contract:IContract;order:IOrder;orderState:IOrderState);dispid 101;
    // execDetailsEx :  
   procedure execDetailsEx(reqId:Integer;contract:IContract;execution:IExecution);dispid 102;
    // updatePortfolioEx :  
   procedure updatePortfolioEx(contract:IContract;position:Integer;marketPrice:Double;marketValue:Double;averageCost:Double;unrealizedPNL:Double;realizedPNL:Double;accountName:WideString);dispid 103;
    // scannerDataEx :  
   procedure scannerDataEx(reqId:Integer;rank:Integer;contractDetails:IContractDetails;distance:WideString;benchmark:WideString;projection:WideString;legsStr:WideString);dispid 104;
    // commissionReport :  
   procedure commissionReport(commissionReport:ICommissionReport);dispid 105;
    // position :  
   procedure position(account:WideString;contract:IContract;position:Integer;avgCost:Double);dispid 106;
    // positionEnd :  
   procedure positionEnd;dispid 107;
    // accountSummary :  
   procedure accountSummary(reqId:Integer;account:WideString;tag:WideString;value:WideString;curency:WideString);dispid 108;
    // accountSummaryEnd :  
   procedure accountSummaryEnd(reqId:Integer);dispid 109;
    // verifyMessageAPI :  
   procedure verifyMessageAPI(apiData:WideString);dispid 110;
    // verifyCompleted :  
   procedure verifyCompleted(isSuccessful:Integer;errorText:WideString);dispid 111;
    // displayGroupList :  
   procedure displayGroupList(reqId:Integer;groups:WideString);dispid 112;
    // displayGroupUpdated :  
   procedure displayGroupUpdated(reqId:Integer;contractInfo:WideString);dispid 113;
  end;

//CoClasses
  T_DTwsEventstickPrice = procedure(Sender: TObject;id:Integer;tickType:Integer;price:Double;canAutoExecute:SYSINT) of object;
  T_DTwsEventstickSize = procedure(Sender: TObject;id:Integer;tickType:Integer;size:Integer) of object;
  T_DTwsEventsconnectionClosed = procedure(Sender: TObject) of object;
  T_DTwsEventsopenOrder1 = procedure(Sender: TObject;id:Integer;symbol:WideString;secType:WideString;expiry:WideString;strike:Double;right:WideString;exchange:WideString;curency:WideString;localSymbol:WideString) of object;
  T_DTwsEventsopenOrder2 = procedure(Sender: TObject;id:Integer;action:WideString;quantity:Integer;orderType:WideString;lmtPrice:Double;auxPrice:Double;tif:WideString;ocaGroup:WideString;account:WideString;openClose:WideString;origin:Integer;orderRef:WideString;clientId:Integer) of object;
  T_DTwsEventsupdateAccountTime = procedure(Sender: TObject;timeStamp:WideString) of object;
  T_DTwsEventsupdateAccountValue = procedure(Sender: TObject;key:WideString;value:WideString;curency:WideString;accountName:WideString) of object;
  T_DTwsEventsnextValidId = procedure(Sender: TObject;id:Integer) of object;
  T_DTwsEventspermId = procedure(Sender: TObject;id:Integer;permId:Integer) of object;
  T_DTwsEventserrMsg = procedure(Sender: TObject;id:Integer;errorCode:Integer;errorMsg:WideString) of object;
  T_DTwsEventsupdatePortfolio = procedure(Sender: TObject;symbol:WideString;secType:WideString;expiry:WideString;strike:Double;right:WideString;curency:WideString;localSymbol:WideString;position:Integer;marketPrice:Double;marketValue:Double;averageCost:Double;unrealizedPNL:Double;realizedPNL:Double;accountName:WideString) of object;
  T_DTwsEventsorderStatus = procedure(Sender: TObject;id:Integer;status:WideString;filled:Integer;remaining:Integer;avgFillPrice:Double;permId:Integer;parentId:Integer;lastFillPrice:Double;clientId:Integer;whyHeld:WideString) of object;
  T_DTwsEventscontractDetails = procedure(Sender: TObject;symbol:WideString;secType:WideString;expiry:WideString;strike:Double;right:WideString;exchange:WideString;curency:WideString;localSymbol:WideString;marketName:WideString;tradingClass:WideString;conId:Integer;minTick:Double;priceMagnifier:Integer;multiplier:WideString;orderTypes:WideString;validExchanges:WideString) of object;
  T_DTwsEventsexecDetails = procedure(Sender: TObject;id:Integer;symbol:WideString;secType:WideString;expiry:WideString;strike:Double;right:WideString;cExchange:WideString;curency:WideString;localSymbol:WideString;execId:WideString;time:WideString;acctNumber:WideString;eExchange:WideString;side:WideString;shares:Integer;price:Double;permId:Integer;clientId:Integer;isLiquidation:SYSINT) of object;
  T_DTwsEventsupdateMktDepth = procedure(Sender: TObject;id:Integer;position:Integer;operation:Integer;side:Integer;price:Double;size:Integer) of object;
  T_DTwsEventsupdateMktDepthL2 = procedure(Sender: TObject;id:Integer;position:Integer;marketMaker:WideString;operation:Integer;side:Integer;price:Double;size:Integer) of object;
  T_DTwsEventsupdateNewsBulletin = procedure(Sender: TObject;msgId:Smallint;msgType:Smallint;message:WideString;origExchange:WideString) of object;
  T_DTwsEventsmanagedAccounts = procedure(Sender: TObject;accountsList:WideString) of object;
  T_DTwsEventsopenOrder3 = procedure(Sender: TObject;id:Integer;symbol:WideString;secType:WideString;expiry:WideString;strike:Double;right:WideString;exchange:WideString;curency:WideString;localSymbol:WideString;action:WideString;quantity:Integer;orderType:WideString;lmtPrice:Double;auxPrice:Double;tif:WideString;ocaGroup:WideString;account:WideString;openClose:WideString;origin:Integer;orderRef:WideString;clientId:Integer;permId:Integer;sharesAllocation:WideString;faGroup:WideString;faMethod:WideString;faPercentage:WideString;faProfile:WideString;goodAfterTime:WideString;goodTillDate:WideString) of object;
  T_DTwsEventsreceiveFA = procedure(Sender: TObject;faDataType:Integer;cxml:WideString) of object;
  T_DTwsEventshistoricalData = procedure(Sender: TObject;reqId:Integer;date:WideString;open:Double;high:Double;low:Double;close:Double;volume:Integer;barCount:Integer;WAP:Double;hasGaps:Integer) of object;
  T_DTwsEventsopenOrder4 = procedure(Sender: TObject;id:Integer;symbol:WideString;secType:WideString;expiry:WideString;strike:Double;right:WideString;exchange:WideString;curency:WideString;localSymbol:WideString;action:WideString;quantity:Integer;orderType:WideString;lmtPrice:Double;auxPrice:Double;tif:WideString;ocaGroup:WideString;account:WideString;openClose:WideString;origin:Integer;orderRef:WideString;clientId:Integer;permId:Integer;sharesAllocation:WideString;faGroup:WideString;faMethod:WideString;faPercentage:WideString;faProfile:WideString;goodAfterTime:WideString;goodTillDate:WideString;ocaType:Integer;rule80A:WideString;settlingFirm:WideString;allOrNone:SYSINT;minQty:Integer;percentOffset:Double;eTradeOnly:SYSINT;firmQuoteOnly:SYSINT;nbboPriceCap:Double;auctionStrategy:Integer;startingPrice:Double;stockRefPrice:Double;delta:Double;stockRangeLower:Double;stockRangeUpper:Double;blockOrder:SYSINT;sweepToFill:SYSINT;ignoreRth:SYSINT;hidden:SYSINT;discretionaryAmt:Double;displaySize:Integer;parentId:Integer;triggerMethod:Integer;shortSaleSlot:Integer;designatedLocation:WideString;volatility:Double;volatilityType:Integer;deltaNeutralOrderType:WideString;deltaNeutralAuxPrice:Double;continuousUpdate:SYSINT;referencePriceType:SYSINT;trailStopPrice:Double;basisPoints:Double;basisPointsType:Integer;legsStr:WideString;scaleInitLevelSize:Integer;scaleSubsLevelSize:Integer;scalePriceIncrement:Double) of object;
  T_DTwsEventsbondContractDetails = procedure(Sender: TObject;symbol:WideString;secType:WideString;cusip:WideString;coupon:Double;maturity:WideString;issueDate:WideString;ratings:WideString;bondType:WideString;couponType:WideString;convertible:Integer;callable:Integer;putable:Integer;descAppend:WideString;exchange:WideString;curency:WideString;marketName:WideString;tradingClass:WideString;conId:Integer;minTick:Double;orderTypes:WideString;validExchanges:WideString;nextOptionDate:WideString;nextOptionType:WideString;nextOptionPartial:Integer;notes:WideString) of object;
  T_DTwsEventsscannerParameters = procedure(Sender: TObject;xml:WideString) of object;
  T_DTwsEventsscannerData = procedure(Sender: TObject;reqId:Integer;rank:Integer;symbol:WideString;secType:WideString;expiry:WideString;strike:Double;right:WideString;exchange:WideString;curency:WideString;localSymbol:WideString;marketName:WideString;tradingClass:WideString;distance:WideString;benchmark:WideString;projection:WideString;legsStr:WideString) of object;
  T_DTwsEventstickOptionComputation = procedure(Sender: TObject;id:Integer;tickType:Integer;impliedVol:Double;delta:Double;optPrice:Double;pvDividend:Double;gamma:Double;vega:Double;theta:Double;undPrice:Double) of object;
  T_DTwsEventstickGeneric = procedure(Sender: TObject;id:Integer;tickType:Integer;value:Double) of object;
  T_DTwsEventstickString = procedure(Sender: TObject;id:Integer;tickType:Integer;value:WideString) of object;
  T_DTwsEventstickEFP = procedure(Sender: TObject;tickerId:Integer;field:Integer;basisPoints:Double;formattedBasisPoints:WideString;totalDividends:Double;holdDays:Integer;futureExpiry:WideString;dividendImpact:Double;dividendsToExpiry:Double) of object;
  T_DTwsEventsrealtimeBar = procedure(Sender: TObject;tickerId:Integer;time:Integer;open:Double;high:Double;low:Double;close:Double;volume:Integer;WAP:Double;Count:Integer) of object;
  T_DTwsEventscurrentTime = procedure(Sender: TObject;time:Integer) of object;
  T_DTwsEventsscannerDataEnd = procedure(Sender: TObject;reqId:Integer) of object;
  T_DTwsEventsfundamentalData = procedure(Sender: TObject;reqId:Integer;data:WideString) of object;
  T_DTwsEventscontractDetailsEnd = procedure(Sender: TObject;reqId:Integer) of object;
  T_DTwsEventsopenOrderEnd = procedure(Sender: TObject) of object;
  T_DTwsEventsaccountDownloadEnd = procedure(Sender: TObject;accountName:WideString) of object;
  T_DTwsEventsexecDetailsEnd = procedure(Sender: TObject;reqId:Integer) of object;
  T_DTwsEventsdeltaNeutralValidation = procedure(Sender: TObject;reqId:Integer;underComp:IUnderComp) of object;
  T_DTwsEventstickSnapshotEnd = procedure(Sender: TObject;reqId:Integer) of object;
  T_DTwsEventsmarketDataType = procedure(Sender: TObject;reqId:Integer;marketDataType:Integer) of object;
  T_DTwsEventscontractDetailsEx = procedure(Sender: TObject;reqId:Integer;contractDetails:IContractDetails) of object;
  T_DTwsEventsopenOrderEx = procedure(Sender: TObject;orderId:Integer;contract:IContract;order:IOrder;orderState:IOrderState) of object;
  T_DTwsEventsexecDetailsEx = procedure(Sender: TObject;reqId:Integer;contract:IContract;execution:IExecution) of object;
  T_DTwsEventsupdatePortfolioEx = procedure(Sender: TObject;contract:IContract;position:Integer;marketPrice:Double;marketValue:Double;averageCost:Double;unrealizedPNL:Double;realizedPNL:Double;accountName:WideString) of object;
  T_DTwsEventsscannerDataEx = procedure(Sender: TObject;reqId:Integer;rank:Integer;contractDetails:IContractDetails;distance:WideString;benchmark:WideString;projection:WideString;legsStr:WideString) of object;
  T_DTwsEventscommissionReport = procedure(Sender: TObject;commissionReport:ICommissionReport) of object;
  T_DTwsEventsposition = procedure(Sender: TObject;account:WideString;contract:IContract;position:Integer;avgCost:Double) of object;
  T_DTwsEventspositionEnd = procedure(Sender: TObject) of object;
  T_DTwsEventsaccountSummary = procedure(Sender: TObject;reqId:Integer;account:WideString;tag:WideString;value:WideString;curency:WideString) of object;
  T_DTwsEventsaccountSummaryEnd = procedure(Sender: TObject;reqId:Integer) of object;
  T_DTwsEventsverifyMessageAPI = procedure(Sender: TObject;apiData:WideString) of object;
  T_DTwsEventsverifyCompleted = procedure(Sender: TObject;isSuccessful:Integer;errorText:WideString) of object;
  T_DTwsEventsdisplayGroupList = procedure(Sender: TObject;reqId:Integer;groups:WideString) of object;
  T_DTwsEventsdisplayGroupUpdated = procedure(Sender: TObject;reqId:Integer;contractInfo:WideString) of object;


  CoTws = Class
  Public
    Class Function Create: _DTws;
    Class Function CreateRemote(const MachineName: string): _DTws;
  end;

  TEvsTws = Class(TEventSink)
  Private
    FOntickPrice:T_DTwsEventstickPrice;
    FOntickSize:T_DTwsEventstickSize;
    FOnconnectionClosed:T_DTwsEventsconnectionClosed;
    FOnopenOrder1:T_DTwsEventsopenOrder1;
    FOnopenOrder2:T_DTwsEventsopenOrder2;
    FOnupdateAccountTime:T_DTwsEventsupdateAccountTime;
    FOnupdateAccountValue:T_DTwsEventsupdateAccountValue;
    FOnnextValidId:T_DTwsEventsnextValidId;
    FOnpermId:T_DTwsEventspermId;
    FOnerrMsg:T_DTwsEventserrMsg;
    FOnupdatePortfolio:T_DTwsEventsupdatePortfolio;
    FOnorderStatus:T_DTwsEventsorderStatus;
    FOncontractDetails:T_DTwsEventscontractDetails;
    FOnexecDetails:T_DTwsEventsexecDetails;
    FOnupdateMktDepth:T_DTwsEventsupdateMktDepth;
    FOnupdateMktDepthL2:T_DTwsEventsupdateMktDepthL2;
    FOnupdateNewsBulletin:T_DTwsEventsupdateNewsBulletin;
    FOnmanagedAccounts:T_DTwsEventsmanagedAccounts;
    FOnopenOrder3:T_DTwsEventsopenOrder3;
    FOnreceiveFA:T_DTwsEventsreceiveFA;
    FOnhistoricalData:T_DTwsEventshistoricalData;
    FOnopenOrder4:T_DTwsEventsopenOrder4;
    FOnbondContractDetails:T_DTwsEventsbondContractDetails;
    FOnscannerParameters:T_DTwsEventsscannerParameters;
    FOnscannerData:T_DTwsEventsscannerData;
    FOntickOptionComputation:T_DTwsEventstickOptionComputation;
    FOntickGeneric:T_DTwsEventstickGeneric;
    FOntickString:T_DTwsEventstickString;
    FOntickEFP:T_DTwsEventstickEFP;
    FOnrealtimeBar:T_DTwsEventsrealtimeBar;
    FOncurrentTime:T_DTwsEventscurrentTime;
    FOnscannerDataEnd:T_DTwsEventsscannerDataEnd;
    FOnfundamentalData:T_DTwsEventsfundamentalData;
    FOncontractDetailsEnd:T_DTwsEventscontractDetailsEnd;
    FOnopenOrderEnd:T_DTwsEventsopenOrderEnd;
    FOnaccountDownloadEnd:T_DTwsEventsaccountDownloadEnd;
    FOnexecDetailsEnd:T_DTwsEventsexecDetailsEnd;
    FOndeltaNeutralValidation:T_DTwsEventsdeltaNeutralValidation;
    FOntickSnapshotEnd:T_DTwsEventstickSnapshotEnd;
    FOnmarketDataType:T_DTwsEventsmarketDataType;
    FOncontractDetailsEx:T_DTwsEventscontractDetailsEx;
    FOnopenOrderEx:T_DTwsEventsopenOrderEx;
    FOnexecDetailsEx:T_DTwsEventsexecDetailsEx;
    FOnupdatePortfolioEx:T_DTwsEventsupdatePortfolioEx;
    FOnscannerDataEx:T_DTwsEventsscannerDataEx;
    FOncommissionReport:T_DTwsEventscommissionReport;
    FOnposition:T_DTwsEventsposition;
    FOnpositionEnd:T_DTwsEventspositionEnd;
    FOnaccountSummary:T_DTwsEventsaccountSummary;
    FOnaccountSummaryEnd:T_DTwsEventsaccountSummaryEnd;
    FOnverifyMessageAPI:T_DTwsEventsverifyMessageAPI;
    FOnverifyCompleted:T_DTwsEventsverifyCompleted;
    FOndisplayGroupList:T_DTwsEventsdisplayGroupList;
    FOndisplayGroupUpdated:T_DTwsEventsdisplayGroupUpdated;

    fServer:_DTws;
    procedure EventSinkInvoke(Sender: TObject; DispID: Integer;
          const IID: TGUID; LocaleID: Integer; Flags: Word;
          Params: tagDISPPARAMS; VarResult, ExcepInfo, ArgErr: Pointer);
  Public
    constructor Create(TheOwner: TComponent); override;
    property ComServer:_DTws read fServer;
    property OntickPrice : T_DTwsEventstickPrice read FOntickPrice write FOntickPrice;
    property OntickSize : T_DTwsEventstickSize read FOntickSize write FOntickSize;
    property OnconnectionClosed : T_DTwsEventsconnectionClosed read FOnconnectionClosed write FOnconnectionClosed;
    property OnopenOrder1 : T_DTwsEventsopenOrder1 read FOnopenOrder1 write FOnopenOrder1;
    property OnopenOrder2 : T_DTwsEventsopenOrder2 read FOnopenOrder2 write FOnopenOrder2;
    property OnupdateAccountTime : T_DTwsEventsupdateAccountTime read FOnupdateAccountTime write FOnupdateAccountTime;
    property OnupdateAccountValue : T_DTwsEventsupdateAccountValue read FOnupdateAccountValue write FOnupdateAccountValue;
    property OnnextValidId : T_DTwsEventsnextValidId read FOnnextValidId write FOnnextValidId;
    property OnpermId : T_DTwsEventspermId read FOnpermId write FOnpermId;
    property OnerrMsg : T_DTwsEventserrMsg read FOnerrMsg write FOnerrMsg;
    property OnupdatePortfolio : T_DTwsEventsupdatePortfolio read FOnupdatePortfolio write FOnupdatePortfolio;
    property OnorderStatus : T_DTwsEventsorderStatus read FOnorderStatus write FOnorderStatus;
    property OncontractDetails : T_DTwsEventscontractDetails read FOncontractDetails write FOncontractDetails;
    property OnexecDetails : T_DTwsEventsexecDetails read FOnexecDetails write FOnexecDetails;
    property OnupdateMktDepth : T_DTwsEventsupdateMktDepth read FOnupdateMktDepth write FOnupdateMktDepth;
    property OnupdateMktDepthL2 : T_DTwsEventsupdateMktDepthL2 read FOnupdateMktDepthL2 write FOnupdateMktDepthL2;
    property OnupdateNewsBulletin : T_DTwsEventsupdateNewsBulletin read FOnupdateNewsBulletin write FOnupdateNewsBulletin;
    property OnmanagedAccounts : T_DTwsEventsmanagedAccounts read FOnmanagedAccounts write FOnmanagedAccounts;
    property OnopenOrder3 : T_DTwsEventsopenOrder3 read FOnopenOrder3 write FOnopenOrder3;
    property OnreceiveFA : T_DTwsEventsreceiveFA read FOnreceiveFA write FOnreceiveFA;
    property OnhistoricalData : T_DTwsEventshistoricalData read FOnhistoricalData write FOnhistoricalData;
    property OnopenOrder4 : T_DTwsEventsopenOrder4 read FOnopenOrder4 write FOnopenOrder4;
    property OnbondContractDetails : T_DTwsEventsbondContractDetails read FOnbondContractDetails write FOnbondContractDetails;
    property OnscannerParameters : T_DTwsEventsscannerParameters read FOnscannerParameters write FOnscannerParameters;
    property OnscannerData : T_DTwsEventsscannerData read FOnscannerData write FOnscannerData;
    property OntickOptionComputation : T_DTwsEventstickOptionComputation read FOntickOptionComputation write FOntickOptionComputation;
    property OntickGeneric : T_DTwsEventstickGeneric read FOntickGeneric write FOntickGeneric;
    property OntickString : T_DTwsEventstickString read FOntickString write FOntickString;
    property OntickEFP : T_DTwsEventstickEFP read FOntickEFP write FOntickEFP;
    property OnrealtimeBar : T_DTwsEventsrealtimeBar read FOnrealtimeBar write FOnrealtimeBar;
    property OncurrentTime : T_DTwsEventscurrentTime read FOncurrentTime write FOncurrentTime;
    property OnscannerDataEnd : T_DTwsEventsscannerDataEnd read FOnscannerDataEnd write FOnscannerDataEnd;
    property OnfundamentalData : T_DTwsEventsfundamentalData read FOnfundamentalData write FOnfundamentalData;
    property OncontractDetailsEnd : T_DTwsEventscontractDetailsEnd read FOncontractDetailsEnd write FOncontractDetailsEnd;
    property OnopenOrderEnd : T_DTwsEventsopenOrderEnd read FOnopenOrderEnd write FOnopenOrderEnd;
    property OnaccountDownloadEnd : T_DTwsEventsaccountDownloadEnd read FOnaccountDownloadEnd write FOnaccountDownloadEnd;
    property OnexecDetailsEnd : T_DTwsEventsexecDetailsEnd read FOnexecDetailsEnd write FOnexecDetailsEnd;
    property OndeltaNeutralValidation : T_DTwsEventsdeltaNeutralValidation read FOndeltaNeutralValidation write FOndeltaNeutralValidation;
    property OntickSnapshotEnd : T_DTwsEventstickSnapshotEnd read FOntickSnapshotEnd write FOntickSnapshotEnd;
    property OnmarketDataType : T_DTwsEventsmarketDataType read FOnmarketDataType write FOnmarketDataType;
    property OncontractDetailsEx : T_DTwsEventscontractDetailsEx read FOncontractDetailsEx write FOncontractDetailsEx;
    property OnopenOrderEx : T_DTwsEventsopenOrderEx read FOnopenOrderEx write FOnopenOrderEx;
    property OnexecDetailsEx : T_DTwsEventsexecDetailsEx read FOnexecDetailsEx write FOnexecDetailsEx;
    property OnupdatePortfolioEx : T_DTwsEventsupdatePortfolioEx read FOnupdatePortfolioEx write FOnupdatePortfolioEx;
    property OnscannerDataEx : T_DTwsEventsscannerDataEx read FOnscannerDataEx write FOnscannerDataEx;
    property OncommissionReport : T_DTwsEventscommissionReport read FOncommissionReport write FOncommissionReport;
    property Onposition : T_DTwsEventsposition read FOnposition write FOnposition;
    property OnpositionEnd : T_DTwsEventspositionEnd read FOnpositionEnd write FOnpositionEnd;
    property OnaccountSummary : T_DTwsEventsaccountSummary read FOnaccountSummary write FOnaccountSummary;
    property OnaccountSummaryEnd : T_DTwsEventsaccountSummaryEnd read FOnaccountSummaryEnd write FOnaccountSummaryEnd;
    property OnverifyMessageAPI : T_DTwsEventsverifyMessageAPI read FOnverifyMessageAPI write FOnverifyMessageAPI;
    property OnverifyCompleted : T_DTwsEventsverifyCompleted read FOnverifyCompleted write FOnverifyCompleted;
    property OndisplayGroupList : T_DTwsEventsdisplayGroupList read FOndisplayGroupList write FOndisplayGroupList;
    property OndisplayGroupUpdated : T_DTwsEventsdisplayGroupUpdated read FOndisplayGroupUpdated write FOndisplayGroupUpdated;

  end;

implementation

uses comobj;

Class Function CoTws.Create: _DTws;
begin
  Result := CreateComObject(CLASS_Tws) as _DTws;
end;

Class Function CoTws.CreateRemote(const MachineName: string): _DTws;
begin
  Result := CreateRemoteComObject(MachineName,CLASS_Tws) as _DTws;
end;

constructor TEvsTws.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  OnInvoke:=EventSinkInvoke;
  fServer:=CoTws.Create;
  Connect(fServer,_DTwsEvents);
end;

procedure TEvsTws.EventSinkInvoke(Sender: TObject; DispID: Integer;
  const IID: TGUID; LocaleID: Integer; Flags: Word; Params: tagDISPPARAMS;
  VarResult, ExcepInfo, ArgErr: Pointer);
begin
  case DispID of
    1: if assigned(OntickPrice) then
          OntickPrice(Self, OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    2: if assigned(OntickSize) then
          OntickSize(Self, OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    3: if assigned(OnconnectionClosed) then
          OnconnectionClosed(Self);
    4: if assigned(OnopenOrder1) then
          OnopenOrder1(Self, OleVariant(Params.rgvarg[8]), OleVariant(Params.rgvarg[7]), OleVariant(Params.rgvarg[6]), OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    5: if assigned(OnopenOrder2) then
          OnopenOrder2(Self, OleVariant(Params.rgvarg[12]), OleVariant(Params.rgvarg[11]), OleVariant(Params.rgvarg[10]), OleVariant(Params.rgvarg[9]), OleVariant(Params.rgvarg[8]), OleVariant(Params.rgvarg[7]), OleVariant(Params.rgvarg[6]), OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    6: if assigned(OnupdateAccountTime) then
          OnupdateAccountTime(Self, OleVariant(Params.rgvarg[0]));
    7: if assigned(OnupdateAccountValue) then
          OnupdateAccountValue(Self, OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    8: if assigned(OnnextValidId) then
          OnnextValidId(Self, OleVariant(Params.rgvarg[0]));
    10: if assigned(OnpermId) then
          OnpermId(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    11: if assigned(OnerrMsg) then
          OnerrMsg(Self, OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    12: if assigned(OnupdatePortfolio) then
          OnupdatePortfolio(Self, OleVariant(Params.rgvarg[13]), OleVariant(Params.rgvarg[12]), OleVariant(Params.rgvarg[11]), OleVariant(Params.rgvarg[10]), OleVariant(Params.rgvarg[9]), OleVariant(Params.rgvarg[8]), OleVariant(Params.rgvarg[7]), OleVariant(Params.rgvarg[6]), OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    13: if assigned(OnorderStatus) then
          OnorderStatus(Self, OleVariant(Params.rgvarg[9]), OleVariant(Params.rgvarg[8]), OleVariant(Params.rgvarg[7]), OleVariant(Params.rgvarg[6]), OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    14: if assigned(OncontractDetails) then
          OncontractDetails(Self, OleVariant(Params.rgvarg[15]), OleVariant(Params.rgvarg[14]), OleVariant(Params.rgvarg[13]), OleVariant(Params.rgvarg[12]), OleVariant(Params.rgvarg[11]), OleVariant(Params.rgvarg[10]), OleVariant(Params.rgvarg[9]), OleVariant(Params.rgvarg[8]), OleVariant(Params.rgvarg[7]), OleVariant(Params.rgvarg[6]), OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    15: if assigned(OnexecDetails) then
          OnexecDetails(Self, OleVariant(Params.rgvarg[18]), OleVariant(Params.rgvarg[17]), OleVariant(Params.rgvarg[16]), OleVariant(Params.rgvarg[15]), OleVariant(Params.rgvarg[14]), OleVariant(Params.rgvarg[13]), OleVariant(Params.rgvarg[12]), OleVariant(Params.rgvarg[11]), OleVariant(Params.rgvarg[10]), OleVariant(Params.rgvarg[9]), OleVariant(Params.rgvarg[8]), OleVariant(Params.rgvarg[7]), OleVariant(Params.rgvarg[6]), OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    16: if assigned(OnupdateMktDepth) then
          OnupdateMktDepth(Self, OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    17: if assigned(OnupdateMktDepthL2) then
          OnupdateMktDepthL2(Self, OleVariant(Params.rgvarg[6]), OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    18: if assigned(OnupdateNewsBulletin) then
          OnupdateNewsBulletin(Self, OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    19: if assigned(OnmanagedAccounts) then
          OnmanagedAccounts(Self, OleVariant(Params.rgvarg[0]));
    20: if assigned(OnopenOrder3) then
          OnopenOrder3(Self, OleVariant(Params.rgvarg[28]), OleVariant(Params.rgvarg[27]), OleVariant(Params.rgvarg[26]), OleVariant(Params.rgvarg[25]), OleVariant(Params.rgvarg[24]), OleVariant(Params.rgvarg[23]), OleVariant(Params.rgvarg[22]), OleVariant(Params.rgvarg[21]), OleVariant(Params.rgvarg[20]), OleVariant(Params.rgvarg[19]), OleVariant(Params.rgvarg[18]), OleVariant(Params.rgvarg[17]), OleVariant(Params.rgvarg[16]), OleVariant(Params.rgvarg[15]), OleVariant(Params.rgvarg[14]), OleVariant(Params.rgvarg[13]), OleVariant(Params.rgvarg[12]), OleVariant(Params.rgvarg[11]), OleVariant(Params.rgvarg[10]), OleVariant(Params.rgvarg[9]), OleVariant(Params.rgvarg[8]), OleVariant(Params.rgvarg[7]), OleVariant(Params.rgvarg[6]), OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    21: if assigned(OnreceiveFA) then
          OnreceiveFA(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    22: if assigned(OnhistoricalData) then
          OnhistoricalData(Self, OleVariant(Params.rgvarg[9]), OleVariant(Params.rgvarg[8]), OleVariant(Params.rgvarg[7]), OleVariant(Params.rgvarg[6]), OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    23: if assigned(OnopenOrder4) then
          OnopenOrder4(Self, OleVariant(Params.rgvarg[66]), OleVariant(Params.rgvarg[65]), OleVariant(Params.rgvarg[64]), OleVariant(Params.rgvarg[63]), OleVariant(Params.rgvarg[62]), OleVariant(Params.rgvarg[61]), OleVariant(Params.rgvarg[60]), OleVariant(Params.rgvarg[59]), OleVariant(Params.rgvarg[58]), OleVariant(Params.rgvarg[57]), OleVariant(Params.rgvarg[56]), OleVariant(Params.rgvarg[55]), OleVariant(Params.rgvarg[54]), OleVariant(Params.rgvarg[53]), OleVariant(Params.rgvarg[52]), OleVariant(Params.rgvarg[51]), OleVariant(Params.rgvarg[50]), OleVariant(Params.rgvarg[49]), OleVariant(Params.rgvarg[48]), OleVariant(Params.rgvarg[47]), OleVariant(Params.rgvarg[46]), OleVariant(Params.rgvarg[45]), OleVariant(Params.rgvarg[44]), OleVariant(Params.rgvarg[43]), OleVariant(Params.rgvarg[42]), OleVariant(Params.rgvarg[41]), OleVariant(Params.rgvarg[40]), OleVariant(Params.rgvarg[39]), OleVariant(Params.rgvarg[38]), OleVariant(Params.rgvarg[37]), OleVariant(Params.rgvarg[36]), OleVariant(Params.rgvarg[35]), OleVariant(Params.rgvarg[34]), OleVariant(Params.rgvarg[33]), OleVariant(Params.rgvarg[32]), OleVariant(Params.rgvarg[31]), OleVariant(Params.rgvarg[30]), OleVariant(Params.rgvarg[29]), OleVariant(Params.rgvarg[28]), OleVariant(Params.rgvarg[27]), OleVariant(Params.rgvarg[26]), OleVariant(Params.rgvarg[25]), OleVariant(Params.rgvarg[24]), OleVariant(Params.rgvarg[23]), OleVariant(Params.rgvarg[22]), OleVariant(Params.rgvarg[21]), OleVariant(Params.rgvarg[20]), OleVariant(Params.rgvarg[19]), OleVariant(Params.rgvarg[18]), OleVariant(Params.rgvarg[17]), OleVariant(Params.rgvarg[16]), OleVariant(Params.rgvarg[15]), OleVariant(Params.rgvarg[14]), OleVariant(Params.rgvarg[13]), OleVariant(Params.rgvarg[12]), OleVariant(Params.rgvarg[11]), OleVariant(Params.rgvarg[10]), OleVariant(Params.rgvarg[9]), OleVariant(Params.rgvarg[8]), OleVariant(Params.rgvarg[7]), OleVariant(Params.rgvarg[6]), OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    24: if assigned(OnbondContractDetails) then
          OnbondContractDetails(Self, OleVariant(Params.rgvarg[24]), OleVariant(Params.rgvarg[23]), OleVariant(Params.rgvarg[22]), OleVariant(Params.rgvarg[21]), OleVariant(Params.rgvarg[20]), OleVariant(Params.rgvarg[19]), OleVariant(Params.rgvarg[18]), OleVariant(Params.rgvarg[17]), OleVariant(Params.rgvarg[16]), OleVariant(Params.rgvarg[15]), OleVariant(Params.rgvarg[14]), OleVariant(Params.rgvarg[13]), OleVariant(Params.rgvarg[12]), OleVariant(Params.rgvarg[11]), OleVariant(Params.rgvarg[10]), OleVariant(Params.rgvarg[9]), OleVariant(Params.rgvarg[8]), OleVariant(Params.rgvarg[7]), OleVariant(Params.rgvarg[6]), OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    25: if assigned(OnscannerParameters) then
          OnscannerParameters(Self, OleVariant(Params.rgvarg[0]));
    26: if assigned(OnscannerData) then
          OnscannerData(Self, OleVariant(Params.rgvarg[15]), OleVariant(Params.rgvarg[14]), OleVariant(Params.rgvarg[13]), OleVariant(Params.rgvarg[12]), OleVariant(Params.rgvarg[11]), OleVariant(Params.rgvarg[10]), OleVariant(Params.rgvarg[9]), OleVariant(Params.rgvarg[8]), OleVariant(Params.rgvarg[7]), OleVariant(Params.rgvarg[6]), OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    27: if assigned(OntickOptionComputation) then
          OntickOptionComputation(Self, OleVariant(Params.rgvarg[9]), OleVariant(Params.rgvarg[8]), OleVariant(Params.rgvarg[7]), OleVariant(Params.rgvarg[6]), OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    28: if assigned(OntickGeneric) then
          OntickGeneric(Self, OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    29: if assigned(OntickString) then
          OntickString(Self, OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    30: if assigned(OntickEFP) then
          OntickEFP(Self, OleVariant(Params.rgvarg[8]), OleVariant(Params.rgvarg[7]), OleVariant(Params.rgvarg[6]), OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    31: if assigned(OnrealtimeBar) then
          OnrealtimeBar(Self, OleVariant(Params.rgvarg[8]), OleVariant(Params.rgvarg[7]), OleVariant(Params.rgvarg[6]), OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    32: if assigned(OncurrentTime) then
          OncurrentTime(Self, OleVariant(Params.rgvarg[0]));
    33: if assigned(OnscannerDataEnd) then
          OnscannerDataEnd(Self, OleVariant(Params.rgvarg[0]));
    34: if assigned(OnfundamentalData) then
          OnfundamentalData(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    35: if assigned(OncontractDetailsEnd) then
          OncontractDetailsEnd(Self, OleVariant(Params.rgvarg[0]));
    36: if assigned(OnopenOrderEnd) then
          OnopenOrderEnd(Self);
    37: if assigned(OnaccountDownloadEnd) then
          OnaccountDownloadEnd(Self, OleVariant(Params.rgvarg[0]));
    38: if assigned(OnexecDetailsEnd) then
          OnexecDetailsEnd(Self, OleVariant(Params.rgvarg[0]));
    39: if assigned(OndeltaNeutralValidation) then
          OndeltaNeutralValidation(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    40: if assigned(OntickSnapshotEnd) then
          OntickSnapshotEnd(Self, OleVariant(Params.rgvarg[0]));
    41: if assigned(OnmarketDataType) then
          OnmarketDataType(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    100: if assigned(OncontractDetailsEx) then
          OncontractDetailsEx(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    101: if assigned(OnopenOrderEx) then
          OnopenOrderEx(Self, OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    102: if assigned(OnexecDetailsEx) then
          OnexecDetailsEx(Self, OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    103: if assigned(OnupdatePortfolioEx) then
          OnupdatePortfolioEx(Self, OleVariant(Params.rgvarg[7]), OleVariant(Params.rgvarg[6]), OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    104: if assigned(OnscannerDataEx) then
          OnscannerDataEx(Self, OleVariant(Params.rgvarg[6]), OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    105: if assigned(OncommissionReport) then
          OncommissionReport(Self, OleVariant(Params.rgvarg[0]));
    106: if assigned(Onposition) then
          Onposition(Self, OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    107: if assigned(OnpositionEnd) then
          OnpositionEnd(Self);
    108: if assigned(OnaccountSummary) then
          OnaccountSummary(Self, OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    109: if assigned(OnaccountSummaryEnd) then
          OnaccountSummaryEnd(Self, OleVariant(Params.rgvarg[0]));
    110: if assigned(OnverifyMessageAPI) then
          OnverifyMessageAPI(Self, OleVariant(Params.rgvarg[0]));
    111: if assigned(OnverifyCompleted) then
          OnverifyCompleted(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    112: if assigned(OndisplayGroupList) then
          OndisplayGroupList(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    113: if assigned(OndisplayGroupUpdated) then
          OndisplayGroupUpdated(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));

  end;
end;

end.
