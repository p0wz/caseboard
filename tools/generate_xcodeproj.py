import os, hashlib

def gen_id(name: str) -> str:
    h = hashlib.md5(name.encode("utf-8")).hexdigest().upper()
    return h[:24]

base_dir = "/Users/p0wz/.gemini/antigravity-ide/scratch/Caseboard"
sources_dir = os.path.join(base_dir, "Sources/Caseboard")
tests_dir = os.path.join(base_dir, "Tests/CaseboardTests")

sources_swift = []
for root, _, files in os.walk(sources_dir):
    for f in files:
        if f.endswith(".swift"):
            sources_swift.append(os.path.relpath(os.path.join(root, f), base_dir))
sources_swift.sort()

resources = []
for root, _, files in os.walk(sources_dir):
    for f in files:
        if f.endswith(".json") or f.endswith(".storekit") or f.endswith(".plist") or f.endswith(".jpg") or f.endswith(".png") or f.endswith(".jpeg"):
            resources.append(os.path.relpath(os.path.join(root, f), base_dir))
resources.sort()

tests_swift = []
for root, _, files in os.walk(tests_dir):
    for f in files:
        if f.endswith(".swift"):
            tests_swift.append(os.path.relpath(os.path.join(root, f), base_dir))
tests_swift.sort()

pbx_build_files = []
pbx_file_refs = []
sources_build_phase_files = []
resources_build_phase_files = []
test_sources_build_phase_files = []

for sf in sources_swift:
    file_id = gen_id("FILEREF_" + sf)
    build_id = gen_id("BUILDFILE_" + sf)
    name = os.path.basename(sf)
    pbx_file_refs.append(f'\t\t{file_id} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "{sf}"; sourceTree = SOURCE_ROOT; }};')
    pbx_build_files.append(f'\t\t{build_id} /* {name} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_id} /* {name} */; }};')
    sources_build_phase_files.append(f'\t\t\t\t{build_id} /* {name} in Sources */,')

for rf in resources:
    if rf.endswith("Info.plist"):
        continue  # Handled by build settings
    file_id = gen_id("FILEREF_" + rf)
    build_id = gen_id("BUILDFILE_" + rf)
    if rf.endswith(".json"):
        file_type = "text.json"
    elif rf.endswith(".jpg") or rf.endswith(".jpeg"):
        file_type = "image.jpeg"
    elif rf.endswith(".png"):
        file_type = "image.png"
    else:
        file_type = "text"
    pbx_file_refs.append(f'\t\t{file_id} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = {file_type}; path = "{rf}"; sourceTree = SOURCE_ROOT; }};')
    pbx_build_files.append(f'\t\t{build_id} /* {name} in Resources */ = {{isa = PBXBuildFile; fileRef = {file_id} /* {name} */; }};')
    resources_build_phase_files.append(f'\t\t\t\t{build_id} /* {name} in Resources */,')

for tf in tests_swift:
    file_id = gen_id("FILEREF_" + tf)
    build_id = gen_id("BUILDFILE_" + tf)
    name = os.path.basename(tf)
    pbx_file_refs.append(f'\t\t{file_id} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "{tf}"; sourceTree = SOURCE_ROOT; }};')
    pbx_build_files.append(f'\t\t{build_id} /* {name} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_id} /* {name} */; }};')
    test_sources_build_phase_files.append(f'\t\t\t\t{build_id} /* {name} in Sources */,')

app_product_id = gen_id("PRODUCT_Caseboard.app")
pbx_file_refs.append(f'\t\t{app_product_id} /* Caseboard.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = "Caseboard.app"; sourceTree = BUILT_PRODUCTS_DIR; }};')

test_product_id = gen_id("PRODUCT_CaseboardTests.xctest")
pbx_file_refs.append(f'\t\t{test_product_id} /* CaseboardTests.xctest */ = {{isa = PBXFileReference; explicitFileType = wrapper.cfbundle; includeInIndex = 0; path = "CaseboardTests.xctest"; sourceTree = BUILT_PRODUCTS_DIR; }};')

sources_group_children = []
for f in (sources_swift + [r for r in resources if not r.endswith("Info.plist")]):
    fid = gen_id("FILEREF_" + f)
    bname = os.path.basename(f)
    sources_group_children.append(f'\t\t\t\t{fid} /* {bname} */,')

tests_group_children = []
for f in tests_swift:
    fid = gen_id("FILEREF_" + f)
    bname = os.path.basename(f)
    tests_group_children.append(f'\t\t\t\t{fid} /* {bname} */,')

sources_group_id = gen_id("GROUP_Sources")
tests_group_id = gen_id("GROUP_Tests")
products_group_id = gen_id("GROUP_Products")
main_group_id = gen_id("GROUP_Main")

target_app_id = gen_id("TARGET_Caseboard_App")
target_test_id = gen_id("TARGET_Caseboard_Tests")
target_dep_id = gen_id("TARGET_DEP_Caseboard")
container_proxy_id = gen_id("CONTAINER_PROXY_Caseboard")

app_sources_phase_id = gen_id("PHASE_App_Sources")
app_resources_phase_id = gen_id("PHASE_App_Resources")
app_frameworks_phase_id = gen_id("PHASE_App_Frameworks")

test_sources_phase_id = gen_id("PHASE_Test_Sources")
test_frameworks_phase_id = gen_id("PHASE_Test_Frameworks")
test_resources_phase_id = gen_id("PHASE_Test_Resources")

proj_config_debug_id = gen_id("CFG_Proj_Debug")
proj_config_release_id = gen_id("CFG_Proj_Release")
proj_config_list_id = gen_id("CFGLIST_Proj")

app_config_debug_id = gen_id("CFG_App_Debug")
app_config_release_id = gen_id("CFG_App_Release")
app_config_list_id = gen_id("CFGLIST_App")

test_config_debug_id = gen_id("CFG_Test_Debug")
test_config_release_id = gen_id("CFG_Test_Release")
test_config_list_id = gen_id("CFGLIST_Test")

project_obj_id = gen_id("PROJECT_Caseboard")

pbxproj_content = f"""// !$*UTF8*$!
{{
	archiveVersion = 1;
	classes = {{
	}};
	objectVersion = 56;
	objects = {{

/* Begin PBXBuildFile section */
{os.linesep.join(pbx_build_files)}
/* End PBXBuildFile section */

/* Begin PBXContainerItemProxy section */
		{container_proxy_id} /* PBXContainerItemProxy */ = {{
			isa = PBXContainerItemProxy;
			containerPortal = {project_obj_id} /* Project object */;
			proxyType = 1;
			remoteGlobalIDString = {target_app_id};
			remoteInfo = Caseboard;
		}};
/* End PBXContainerItemProxy section */

/* Begin PBXFileReference section */
{os.linesep.join(pbx_file_refs)}
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		{app_frameworks_phase_id} /* Frameworks */ = {{
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
		{test_frameworks_phase_id} /* Frameworks */ = {{
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		{main_group_id} = {{
			isa = PBXGroup;
			children = (
				{sources_group_id} /* Sources */,
				{tests_group_id} /* Tests */,
				{products_group_id} /* Products */,
			);
			sourceTree = "<group>";
		}};
		{sources_group_id} = {{
			isa = PBXGroup;
			children = (
{os.linesep.join(sources_group_children)}
			);
			name = Sources;
			sourceTree = "<group>";
		}};
		{tests_group_id} = {{
			isa = PBXGroup;
			children = (
{os.linesep.join(tests_group_children)}
			);
			name = Tests;
			sourceTree = "<group>";
		}};
		{products_group_id} = {{
			isa = PBXGroup;
			children = (
				{app_product_id} /* Caseboard.app */,
				{test_product_id} /* CaseboardTests.xctest */,
			);
			name = Products;
			sourceTree = "<group>";
		}};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		{target_app_id} /* Caseboard */ = {{
			isa = PBXNativeTarget;
			buildConfigurationList = {app_config_list_id} /* Build configuration list for PBXNativeTarget "Caseboard" */;
			buildPhases = (
				{app_sources_phase_id} /* Sources */,
				{app_frameworks_phase_id} /* Frameworks */,
				{app_resources_phase_id} /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = Caseboard;
			productName = Caseboard;
			productReference = {app_product_id} /* Caseboard.app */;
			productType = "com.apple.product-type.application";
		}};
		{target_test_id} /* CaseboardTests */ = {{
			isa = PBXNativeTarget;
			buildConfigurationList = {test_config_list_id} /* Build configuration list for PBXNativeTarget "CaseboardTests" */;
			buildPhases = (
				{test_sources_phase_id} /* Sources */,
				{test_frameworks_phase_id} /* Frameworks */,
				{test_resources_phase_id} /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
				{target_dep_id} /* PBXTargetDependency */,
			);
			name = CaseboardTests;
			productName = CaseboardTests;
			productReference = {test_product_id} /* CaseboardTests.xctest */;
			productType = "com.apple.product-type.bundle.unit-test";
		}};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		{project_obj_id} /* Project object */ = {{
			isa = PBXProject;
			attributes = {{
				BuildIndependentTargetsInParallel = 1;
				LastUpgradeCheck = 1600;
				TargetAttributes = {{
					{target_app_id} = {{
						CreatedOnToolsVersion = 16.0;
					}};
					{target_test_id} = {{
						CreatedOnToolsVersion = 16.0;
						TestTargetID = {target_app_id};
					}};
				}};
			}};
			buildConfigurationList = {proj_config_list_id} /* Build configuration list for PBXProject "Caseboard" */;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = {main_group_id};
			productRefGroup = {products_group_id} /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				{target_app_id} /* Caseboard */,
				{target_test_id} /* CaseboardTests */,
			);
		}};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		{app_resources_phase_id} /* Resources */ = {{
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
{os.linesep.join(resources_build_phase_files)}
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
		{test_resources_phase_id} /* Resources */ = {{
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
{os.linesep.join(resources_build_phase_files)}
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		{app_sources_phase_id} /* Sources */ = {{
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
{os.linesep.join(sources_build_phase_files)}
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
		{test_sources_phase_id} /* Sources */ = {{
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
{os.linesep.join(test_sources_build_phase_files)}
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXSourcesBuildPhase section */

/* Begin PBXTargetDependency section */
		{target_dep_id} /* PBXTargetDependency */ = {{
			isa = PBXTargetDependency;
			target = {target_app_id} /* Caseboard */;
			targetProxy = {container_proxy_id} /* PBXContainerItemProxy */;
		}};
/* End PBXTargetDependency section */

/* Begin XCBuildConfiguration section */
		{proj_config_debug_id} /* Debug */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = iphoneos;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = "DEBUG $(inherited)";
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
				SWIFT_VERSION = 5.0;
			}};
			name = Debug;
		}};
		{proj_config_release_id} /* Release */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				GCC_NO_COMMON_BLOCKS = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				MTL_ENABLE_DEBUG_INFO = NO;
				SDKROOT = iphoneos;
				SWIFT_COMPILATION_MODE = wholemodule;
				SWIFT_OPTIMIZATION_LEVEL = "-O";
				SWIFT_VERSION = 5.0;
				VALIDATE_PRODUCT = YES;
			}};
			name = Release;
		}};
		{app_config_debug_id} /* Debug */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = Sources/Caseboard/Info.plist;
				INFOPLIST_KEY_CFBundleDisplayName = Caseboard;
				INFOPLIST_KEY_LSApplicationCategoryType = "public.app-category.puzzle-games";
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.caseboard.detective;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				TARGETED_DEVICE_FAMILY = "1,2";
			}};
			name = Debug;
		}};
		{app_config_release_id} /* Release */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = Sources/Caseboard/Info.plist;
				INFOPLIST_KEY_CFBundleDisplayName = Caseboard;
				INFOPLIST_KEY_LSApplicationCategoryType = "public.app-category.puzzle-games";
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.caseboard.detective;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				TARGETED_DEVICE_FAMILY = "1,2";
			}};
			name = Release;
		}};
		{test_config_debug_id} /* Debug */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = YES;
				BUNDLE_LOADER = "$(TEST_HOST)";
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				GENERATE_INFOPLIST_FILE = YES;
				GENERATE_INFOPLIST_KEY_CFBundleDisplayName = CaseboardTests;
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.caseboard.detective.tests;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = NO;
				TARGETED_DEVICE_FAMILY = "1,2";
				TEST_HOST = "$(BUILT_PRODUCTS_DIR)/Caseboard.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/Caseboard";
			}};
			name = Debug;
		}};
		{test_config_release_id} /* Release */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = YES;
				BUNDLE_LOADER = "$(TEST_HOST)";
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				GENERATE_INFOPLIST_FILE = YES;
				GENERATE_INFOPLIST_KEY_CFBundleDisplayName = CaseboardTests;
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.caseboard.detective.tests;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = NO;
				TARGETED_DEVICE_FAMILY = "1,2";
				TEST_HOST = "$(BUILT_PRODUCTS_DIR)/Caseboard.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/Caseboard";
			}};
			name = Release;
		}};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		{proj_config_list_id} /* Build configuration list for PBXProject "Caseboard" */ = {{
			isa = XCConfigurationList;
			buildConfigurations = (
				{proj_config_debug_id} /* Debug */,
				{proj_config_release_id} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		}};
		{app_config_list_id} /* Build configuration list for PBXNativeTarget "Caseboard" */ = {{
			isa = XCConfigurationList;
			buildConfigurations = (
				{app_config_debug_id} /* Debug */,
				{app_config_release_id} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		}};
		{test_config_list_id} /* Build configuration list for PBXNativeTarget "CaseboardTests" */ = {{
			isa = XCConfigurationList;
			buildConfigurations = (
				{test_config_debug_id} /* Debug */,
				{test_config_release_id} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		}};
/* End XCConfigurationList section */

	}};
	rootObject = {project_obj_id} /* Project object */;
}}
"""

proj_dir = os.path.join(base_dir, "Caseboard.xcodeproj")
os.makedirs(proj_dir, exist_ok=True)
with open(os.path.join(proj_dir, "project.pbxproj"), "w") as f:
    f.write(pbxproj_content)

print("SUCCESS: Updated Caseboard.xcodeproj with all current sources.")
