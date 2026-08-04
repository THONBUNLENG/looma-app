# Implementation Plan - Complete Cambodia Address Data

Complete the list of provinces and districts for Cambodia in the `AddNewAddressScreen` and implement cascading selection.

## Proposed Changes

### Constants

#### [NEW] [address_data.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/constants/address_data.dart)

- Create a new file to store the full list of Cambodian provinces and their corresponding districts.
- Include a translation map for English to Khmer names for all entries.

### Screens

#### [new_address.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/screen/home_screen/address/new_address.dart)

- Import `address_data.dart`.
- Remove hardcoded `khmerDistricts`, `cities`, `districts`, and `communes` from the state class.
- Update `selectedCity` to handle province selection.
- Implement cascading logic:
    - When `selectedCity` (Province) changes, reset `selectedDistrict` and `selectedCommune`, and update the available districts list.
    - When `selectedDistrict` changes, reset `selectedCommune`.
- Update `_buildDropdownField` and `_showSelectionSheet` to use the new data and translation map.
- Ensure the display shows "Khmer / English" format as seen in the current implementation.

## Verification Plan

### Automated Tests
- I will check for any compilation errors after the changes.

### Manual Verification
- Verify that the Province dropdown contains all 25 provinces.
- Verify that selecting a province updates the District dropdown with the correct districts.
- Verify that the display format remains "Khmer / English" for districts.
- Verify that saving the address still returns the correct data.
