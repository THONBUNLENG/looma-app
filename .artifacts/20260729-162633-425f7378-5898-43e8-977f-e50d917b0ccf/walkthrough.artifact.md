# Walkthrough - Complete Cambodia Address Data

I have completed the task of providing the full list of Cambodian provinces and districts in the `AddNewAddressScreen`.

## Changes Made

### Data Layer
- Created [address_data.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/constants/address_data.dart) containing the official list of all 25 provinces and their corresponding districts in both English and Khmer.
- Included recent administrative updates (e.g., Akrey Ksat, Run Ta Ek Techo Sen).

### UI & Logic
- Refactored [new_address.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/screen/home_screen/address/new_address.dart):
    - Replaced hardcoded lists with dynamic data from `address_data.dart`.
    - Implemented **Cascading Selection**:
        - Selecting a Province now automatically filters the list of available Districts.
        - Changing the Province resets the selected District and Commune to prevent invalid combinations.
    - Updated display format to consistently show **"Khmer Name / English Name"** for both Provinces and Districts.

## Verification Summary
- **Static Analysis**: Ran `analyze_file` on [new_address.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/screen/home_screen/address/new_address.dart) and found no errors.
- **Logic Check**:
    - Verified that `cities` getter returns all 25 provinces.
    - Verified that `currentDistricts` correctly filters based on the `selectedCity` (Province).
    - Verified that `getTranslation` correctly handles both provinces and districts for bilingual display.
