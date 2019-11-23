#
#  Be sure to run `pod spec lint XUnikey.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    dir = File.dirname(__FILE__)
    version = '1.0.5'

    # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.name = "XUnikey"
    s.version = version
    s.summary = "A short description of XUnikey."
    s.description = <<-DESC
X-Unikey is Unikey ported to Linux and FreeBSD. X-Unikey lets you type Vietnamese in X Window environment. 
It has been tested with many popular programs, such as OpenOffice, emacs, vim, QT applications, GTK applications… X-Unikey has all the features of the Windows version, except that its GUI is still too simplified. 
All options are set through configuration file or keyboard shortcuts.
    DESC

    s.homepage = "https://www.unikey.org/linux.html"

    # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.license = {:type => "FreeBSD"}


    # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.authors = {
        "Phạm Kim Long" => "http://unikey.org",
        "Nguyễn Thiện Hùng" => "nthung@ninepoints.vn"
    }

    # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.platform = :osx, '10.7'
    # s.platform     = :ios, "5.0"

    #  When using multiple platforms
    # s.ios.deployment_target = "5.0"
    # s.osx.deployment_target = "10.7"
    # s.watchos.deployment_target = "2.0"
    # s.tvos.deployment_target = "9.0"


    # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    #
    #  Specify the location from where the source should be retrieved.
    #  Supports git, hg, bzr, svn and HTTP.
    #

    s.source = {
        :git => "git@bitbucket.org:billow/x-unikey.git",
        :branch => "master"
    }

    # s.static_framework = true


    # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    # Use `xunikey` as framework name so that `#include <xunikey/xxx.h>` works when built as
    # framework.
    s.module_name = s.name

    # Add include prefix `xunikey` so that `#include <xunikey/xxx.h>` works when built as static
    # library.
    s.header_dir = s.name

    s.source_files = [
        "src/objc/*.{h,mm}",
    ]

    # s.exclude_files = "Classes/Exclude"
    s.public_header_files = [
        "src/objc/*.h",
    ]

    s.header_mappings_dir = 'src/objc'

    # s.vendored_libraries = 'libUniversalRelease.a'

    # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    # s.resource  = "icon.png"
    # s.resources = "Resources/*.png"
    # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


    # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    # s.framework = 'CoreFoundation'
    # s.framework  = "SomeFramework"
    # s.frameworks = "SomeFramework", "AnotherFramework"
    s.libraries = 'c++'
    s.pod_target_xcconfig = {
        "HEADER_SEARCH_PATHS" => [
            "$(inherited)",
            "#{dir}/src/byteio",
            "#{dir}/src/vnconv",
            "#{dir}/src/ukengine",
            "#{dir}/src/ukinterface",
        ],
    }

    s.xcconfig = {
        "HEADER_SEARCH_PATHS" => [
            "$(inherited)",
            "#{dir}/src/byteio",
            "#{dir}/src/vnconv",
            "#{dir}/src/ukengine",
            "#{dir}/src/ukinterface",
        ],

        # If we don't set these two settings, `include/grpc/support/time.h` and
        # `src/core/lib/support/string.h` shadow the system `<time.h>` and `<string.h>`, breaking the
        # build.
        'USE_HEADERMAP' => 'NO',
        'ALWAYS_SEARCH_USER_PATHS' => 'NO',
        # 'ENABLE_BITCODE' => 'NO',
        # 'OTHER_LDFLAGS' => "-ObjC -all_load -lz -lc++",
        # 'VALID_ARCHS' => 'x86_64 arm64'
        'VALID_ARCHS' => 'x86_64'
    }


    s.compiler_flags = '-Wno-writable-strings',
        '-Wno-invalid-source-encoding',
        '-Wno-shorten-64-to-32',
        '-Wno-c++-narrowing'

    # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    s.requires_arc = false

    s.default_subspecs = [
        'byteio',
        'vnconv',
        'ukengine',
        'ukinterface',
    ]

    s.subspec 'byteio' do |ss|
        ss.requires_arc = false

        ss.header_mappings_dir = 'src/byteio'
        ss.source_files = "src/byteio/*.{h,c,cc,cpp}"
        ss.private_header_files = "src/byteio/*.{h,hpp}"
    end

    s.subspec 'vnconv' do |ss|
        ss.requires_arc = false
        ss.dependency "#{s.name}/byteio", version

        ss.header_mappings_dir = 'src/vnconv'
        ss.source_files = "src/vnconv/*.{h,hpp,c,cc,cpp}"
        # ss.private_header_files = "src/vnconv/*.{h,hpp}"
        ss.public_header_files = [
            "src/vnconv/{vnconv}.h"
        ]
        ss.exclude_files = "src/vnconv/stdafx.{h,hpp,c,cc,cpp}"
    end

    s.subspec 'ukengine' do |ss|
        ss.requires_arc = false
        ss.dependency "#{s.name}/byteio", version
        ss.dependency "#{s.name}/vnconv", version

        ss.header_mappings_dir = 'src/ukengine'
        ss.source_files = "src/ukengine/*.{h,hpp,c,cc,cpp}"
        # ss.private_header_files = "src/ukengine/{*}.{h,hpp}"
        ss.public_header_files = [
            "src/ukengine/{keycons}.h"
        ]
        ss.exclude_files = "src/ukengine/stdafx.{h,hpp,c,cc,cpp}"
    end

    s.subspec 'ukinterface' do |ss|
        ss.requires_arc = false
        ss.dependency "#{s.name}/byteio", version
        ss.dependency "#{s.name}/vnconv", version
        ss.dependency "#{s.name}/ukengine", version

        ss.header_mappings_dir = 'src/ukinterface'
        ss.source_files = "src/ukinterface/*.{h,hpp,c,cc,cpp}"
        # ss.private_header_files = "src/ukinterface/*.{h,hpp}"
        ss.public_header_files = [
            "src/ukinterface/{unikey}.h"
        ]
    end
end
