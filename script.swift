#!/usr/bin/swift

import Foundation

let ignoredFiles = [ ".DS_Store", ".git", ".gitignore", ".rake_tasks~", "extra", ".", "..", "Gemfile", "Rakefile", "README.md", "script.swift", "Gemfile.lock", "script.playground", "script", "install.sh" ]

let homeURL = URL(string: NSHomeDirectory())!
let sourceURL = URL(string: FileManager.default.currentDirectoryPath)!
let homeFiles = try FileManager.default.contentsOfDirectory(at: homeURL, includingPropertiesForKeys: nil, options: [])
let allFiles = try FileManager.default.contentsOfDirectory(at: sourceURL, includingPropertiesForKeys: nil, options: [])
let files = Set(allFiles.map { $0.lastPathComponent }).subtracting(ignoredFiles)

for file in files {
	let sourcePath = sourceURL.appendingPathComponent(file).absoluteString
	let destinationPath = homeURL.appendingPathComponent(file).absoluteString

	let exist = FileManager.default.fileExists(atPath: destinationPath)
	if !exist {
		//create symlink
		try! FileManager.default.createSymbolicLink(atPath: destinationPath, withDestinationPath: sourcePath)
		print("symlinked")
	} else {
		print("File \(destinationPath) exists. n it (y/n)?")
		if let response = readLine(), response == "y" {
			try! FileManager.default.removeItem(atPath: destinationPath)
			try! FileManager.default.createSymbolicLink(atPath: destinationPath, withDestinationPath: sourcePath)
			print("symlinked")
		} else {
			print("Skipping \(destinationPath).")
		}
	}
}

print("Finished")