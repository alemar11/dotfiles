#!/usr/bin/swift

import Foundation

let ignoredFiles = [
										".DS_Store", 
										".git", 
										".gitignore", 
										".rake_tasks~", 
										"extra", ".", "..", 
										"Gemfile", 
										"Rakefile", 
										"README.md", 
										"script.swift", 
										"Gemfile.lock", 
										"script", 
										"install.sh"
									 ]

let red = "\u{001B}[0;31m"
let green = "\u{001B}[0;32m"
let yellow = "\u{001B}[0;33m"
let blue = "\u{001B}[0;34m"
let magenta = "\u{001B}[0;35m"
let cyan = "\u{001B}[0;36m"
let white = "\u{001B}[0;37m"

extension String {
	func isAlreadySymlinked(to path: String) -> Bool {
		guard FileManager.default.fileExists(atPath: path) else { return false }
		let symlinkPath = try? FileManager.default.destinationOfSymbolicLink(atPath: self)
		if let symlinkPath = symlinkPath, symlinkPath == path {
			return true
		}
		return false
	}
}

let homeURL = URL(string: NSHomeDirectory())!
let sourceURL = URL(string: FileManager.default.currentDirectoryPath)!
let homeFiles = try FileManager.default.contentsOfDirectory(at: homeURL, includingPropertiesForKeys: nil, options: [])
let allFiles = try FileManager.default.contentsOfDirectory(at: sourceURL, includingPropertiesForKeys: nil, options: [])
let files = Set(allFiles.map { $0.lastPathComponent }).subtracting(ignoredFiles)

for file in files {
	let sourcePath = sourceURL.appendingPathComponent(file).absoluteString
	let destinationPath = homeURL.appendingPathComponent(file).absoluteString
	
	if !destinationPath.isAlreadySymlinked(to: sourcePath) {
		try! FileManager.default.createSymbolicLink(atPath: destinationPath, withDestinationPath: sourcePath)
		print("\(green)\(file) has been symlinked.")
		
	} else {
		print("\(white)File \(file) exists. Overwrite it (y/n)?")
		if let response = readLine(), response == "y" {
			try! FileManager.default.removeItem(atPath: destinationPath)
			try! FileManager.default.createSymbolicLink(atPath: destinationPath, withDestinationPath: sourcePath)
			print("\(green)\(file) has been overwritten.")
			
		} else {
			print("\(cyan)Skipped.")
		}
	}
}

print("\n\(white)Completed 🎉")

