package com.zenika;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;
import java.util.Map.Entry;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.xtext.generator.GeneratorDelegate;
import org.eclipse.xtext.generator.InMemoryFileSystemAccess;
import org.eclipse.xtext.resource.XtextResource;
import org.eclipse.xtext.resource.XtextResourceSet;
import org.eclipse.xtext.util.CancelIndicator;
import org.eclipse.xtext.validation.CheckMode;
import org.eclipse.xtext.validation.IResourceValidator;
import org.eclipse.xtext.validation.Issue;

import com.zenika.generator.AicdslGenerator;

public class Generate {
	public static void main(String[] args) {
			
		// do this only once per application
		com.google.inject.Injector injector = new AicdslStandaloneSetup().createInjectorAndDoEMFRegistration();
		
		// obtain a resource set from the injector
		XtextResourceSet resourceSet = injector.getInstance(XtextResourceSet.class);

		// load a resource by URI, in this case from the file system
		try {
			//uri = URI.createFileURI("/home/zenika/Workspace/com.zenika.aicdsl.parent/com.zenika.aicdsl/src/main/java/com/zenika/test.aic");
			URI uri = URI.createFileURI(System.getProperty("user.dir")+"/DslFiles/test.aic");
			Resource resource = resourceSet.getResource(uri, true);
			
			// Validator
			IResourceValidator validator = ((XtextResource)resource).getResourceServiceProvider().getResourceValidator();
			List<Issue> issues = validator.validate(resource, CheckMode.ALL, CancelIndicator.NullImpl);
			for (Issue issue : issues) {
			  System.out.println(issue.getMessage());
			}
			
			// Generator
			AicdslGenerator generator = new AicdslGenerator();
			InMemoryFileSystemAccess fsa = new InMemoryFileSystemAccess();
			generator.doGenerate(resource, fsa);
			for (Entry<String, CharSequence> file : fsa.getTextFiles().entrySet()) {
				  //System.out.println("Generated file contents : "+file.getValue());
				  try {
					BufferedWriter finalFile = new BufferedWriter(new FileWriter(System.getProperty("user.dir")+"/DslFiles/Testing.java"));
					finalFile.write((String) file.getValue());
					finalFile.close();
				  } catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				  
			}
		} catch (Exception e) {
			System.out.println(e);
		}
	}
}