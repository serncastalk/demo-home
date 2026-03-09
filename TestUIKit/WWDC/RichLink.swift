//
//  RichLink.swift
//  TestUIKit
//
//  Created by Duck Sern on 18/2/26.
//

import Foundation

/// `LPMetadataProvider.startFetchingMetadata` : input: weblink
/// Output: metadata of the link title, icon, image and video are all optional
/// Can also be used for local file URLS => get thumbnail of file
/// UI: Use `LPLinkView`: input: `LPLinkMetaData` from above
///
/// Share sheet:
/// - Implement `activityViewControllerLinkMetadata` of `UIActivityItemSource` to provide `LPLinkMetadata`
