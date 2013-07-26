package it.italiangrid.portal.dirac.model;

import java.util.Arrays;
import java.util.List;

public class Jdl {

	private String jobName;
	private String executable;
	private String arguments;
	private List<String> inputSandbox;
	private String outputSandboxRequest;
	private List<String> outputSandbox;
	private List<String> outputSandboxDestUri;
	private String stdOutput;
	private String stdError;
	private List<String> inputData;
	private String outputSE;
	private List<List<String>> outputData;
	private String outputPath;
	private String parameters;
	private String parameterStart;
	private String parameterStep;
	private String cpuNumber;
	private String hostNumber;
	private String wholeNodes;
	private String smpGranularity;
	private String vo;
	private List<String> parameterNames = Arrays.asList(new String[]{ "jobName", "executable", "arguments",
		"inputSandbox", "outputSandboxRequest", "outputSandbox", "outputSandboxDestUri", "stdOutput", "stdError",
		"inputData", "outputSE", "outputData", "outputPath", "parameters", "parameterStart",
		"parameterStep", "cpuNumber", "hostNumber", "wholeNodes", "smpGranularity", "vo"});

	/**
	 * Default constructor.
	 */
	public Jdl() {
		this.jobName = "Portal_Job";
		this.executable = "/bin/ls";
		this.arguments = "-latr";
		this.stdOutput = "StdOut";
		this.stdError = "StdErr";
	}

	/**
	 * 
	 * @param jobName
	 * @param executable
	 * @param arguments
	 * @param inputSandbox
	 * @param outputSandbox
	 * @param outputSandboxDestUri
	 * @param stdOutput
	 * @param stdError
	 * @param inputData
	 * @param outputSE
	 * @param outputData
	 * @param outputPath
	 * @param parameters
	 * @param paramenterStart
	 * @param parameterStep
	 * @param cpuNumber
	 * @param hostNumber
	 * @param wholeNodes
	 * @param smpGranularity
	 */
	public Jdl(String jobName, String executable, String arguments,
			List<String> inputSandbox, List<String> outputSandbox,
			List<String> outputSandboxDestUri, String stdOutput,
			String stdError, List<String> inputData, String outputSE,
			List<List<String>> outputData, String outputPath,
			String parameters, String paramenterStart,
			String parameterStep, String cpuNumber, String hostNumber,
			String wholeNodes, String smpGranularity, String vo) {
		super();
		this.jobName = jobName;
		this.executable = executable;
		this.arguments = arguments;
		this.inputSandbox = inputSandbox;
		this.outputSandbox = outputSandbox;
		this.outputSandboxDestUri = outputSandboxDestUri;
		this.stdOutput = stdOutput;
		this.stdError = stdError;
		this.inputData = inputData;
		this.outputSE = outputSE;
		this.outputData = outputData;
		this.outputPath = outputPath;
		this.parameters = parameters;
		this.parameterStart = paramenterStart;
		this.parameterStep = parameterStep;
		this.cpuNumber = cpuNumber;
		this.hostNumber = hostNumber;
		this.wholeNodes = wholeNodes;
		this.smpGranularity = smpGranularity;
		this.vo = vo;
	}

	/**
	 * @return the jobName
	 */
	public String getJobName() {
		return jobName;
	}

	/**
	 * @param jobName
	 *            the jobName to set
	 */
	public void setJobName(String jobName) {
		this.jobName = jobName;
	}

	/**
	 * @return the executable
	 */
	public String getExecutable() {
		return executable;
	}

	/**
	 * @param executable
	 *            the executable to set
	 */
	public void setExecutable(String executable) {
		this.executable = executable;
	}

	/**
	 * @return the arguments
	 */
	public String getArguments() {
		return arguments;
	}

	/**
	 * @param arguments
	 *            the arguments to set
	 */
	public void setArguments(String arguments) {
		this.arguments = arguments;
	}

	/**
	 * @return the inputSandbox
	 */
	public List<String> getInputSandbox() {
		return inputSandbox;
	}

	/**
	 * @param inputSandbox
	 *            the inputSandbox to set
	 */
	public void setInputSandbox(List<String> inputSandbox) {
		this.inputSandbox = inputSandbox;
	}

	/**
	 * @return the outputSandboxRequest
	 */
	public String getOutputSandboxRequest() {
		return outputSandboxRequest;
	}

	/**
	 * @param outputSandboxRequest
	 *            the outputSandboxRequest to set
	 */
	public void setOutputSandboxRequest(String outputSandboxRequest) {
		this.outputSandboxRequest = outputSandboxRequest;
	}

	/**
	 * @return the outputSandbox
	 */
	public List<String> getOutputSandbox() {
		return outputSandbox;
	}

	/**
	 * @param outputSandbox
	 *            the outputSandbox to set
	 */
	public void setOutputSandbox(List<String> outputSandbox) {
		this.outputSandbox = outputSandbox;
	}

	/**
	 * @return the outputSandboxDestUri
	 */
	public List<String> getOutputSandboxDestUri() {
		return outputSandboxDestUri;
	}

	/**
	 * @param outputSandboxDestUri
	 *            the outputSandboxDestUri to set
	 */
	public void setOutputSandboxDestUri(List<String> outputSandboxDestUri) {
		this.outputSandboxDestUri = outputSandboxDestUri;
	}

	/**
	 * @return the stdOutput
	 */
	public String getStdOutput() {
		return stdOutput;
	}

	/**
	 * @param stdOutput
	 *            the stdOutput to set
	 */
	public void setStdOutput(String stdOutput) {
		this.stdOutput = stdOutput;
	}

	/**
	 * @return the stdError
	 */
	public String getStdError() {
		return stdError;
	}

	/**
	 * @param stdError
	 *            the stdError to set
	 */
	public void setStdError(String stdError) {
		this.stdError = stdError;
	}

	/**
	 * @return the inputData
	 */
	public List<String> getInputData() {
		return inputData;
	}

	/**
	 * @param inputData
	 *            the inputData to set
	 */
	public void setInputData(List<String> inputData) {
		this.inputData = inputData;
	}

	/**
	 * @return the outputSE
	 */
	public String getOutputSE() {
		return outputSE;
	}

	/**
	 * @param outputSE
	 *            the outputSE to set
	 */
	public void setOutputSE(String outputSE) {
		this.outputSE = outputSE;
	}

	/**
	 * @return the outputData
	 */
	public List<List<String>> getOutputData() {
		return outputData;
	}

	/**
	 * @param outputData
	 *            the outputData to set
	 */
	public void setOutputData(List<List<String>> outputData) {
		this.outputData = outputData;
	}

	/**
	 * @return the outputPath
	 */
	public String getOutputPath() {
		return outputPath;
	}

	/**
	 * @param outputPath
	 *            the outputPath to set
	 */
	public void setOutputPath(String outputPath) {
		this.outputPath = outputPath;
	}

	/**
	 * @return the parameters
	 */
	public String getParameters() {
		return parameters;
	}

	/**
	 * @param parameters
	 *            the parameters to set
	 */
	public void setParameters(String parameters) {
		this.parameters = parameters;
	}

	/**
	 * @return the parameterStart
	 */
	public String getParameterStart() {
		return parameterStart;
	}

	/**
	 * @param parameterStart
	 *            the parameterStart to set
	 */
	public void setParameterStart(String parameterStart) {
		this.parameterStart = parameterStart;
	}

	/**
	 * @return the parameterStep
	 */
	public String getParameterStep() {
		return parameterStep;
	}

	/**
	 * @param parameterStep
	 *            the parameterStep to set
	 */
	public void setParameterStep(String parameterStep) {
		this.parameterStep = parameterStep;
	}

	/**
	 * @return the cpuNumber
	 */
	public String getCpuNumber() {
		return cpuNumber;
	}

	/**
	 * @param cpuNumber the cpuNumber to set
	 */
	public void setCpuNumber(String cpuNumber) {
		this.cpuNumber = cpuNumber;
	}

	/**
	 * @return the hostNumber
	 */
	public String getHostNumber() {
		return hostNumber;
	}

	/**
	 * @param hostNumber the hostNumber to set
	 */
	public void setHostNumber(String hostNumber) {
		this.hostNumber = hostNumber;
	}

	/**
	 * @return the wholeNode
	 */
	public String getWholeNodes() {
		return wholeNodes;
	}

	/**
	 * @param wholeNode the wholeNode to set
	 */
	public void setWholeNodes(String wholeNodes) {
		this.wholeNodes = wholeNodes;
	}

	/**
	 * @return the smpGranularity
	 */
	public String getSmpGranularity() {
		return smpGranularity;
	}

	/**
	 * @param smpGranularity the smpGranularity to set
	 */
	public void setSmpGranularity(String smpGranularity) {
		this.smpGranularity = smpGranularity;
	}

	/**
	 * @return the vo
	 */
	public String getVo() {
		return vo;
	}

	/**
	 * @param vo the vo to set
	 */
	public void setVo(String vo) {
		this.vo = vo;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		String string = "";
		
//		if (parameters != null) {
//			string += "JobType = \"Parametric\";\n";
//		}else{
//			string += "JobType = \"Normal\";\n";
//		}
		if (jobName != null) {
			string += "JobName = \"" + jobName + "\";\n";
		}
		if (executable != null) {
			string += "Executable = \"" + executable + "\";\n";
		}
		if (arguments != null && !arguments.isEmpty()) {
			string += "Arguments = \"" + arguments + "\";\n";
		}
		if (vo != null && !vo.isEmpty()) {
			string += "VirtualOrganization = \"" + vo + "\";\n";
		}
		if (stdOutput != null) {
			string += "StdOutput = \"" + stdOutput + "\";\n";
		}
		if (stdError != null) {
			string += "StdError = \"" + stdError + "\";\n";
		}
		if (inputSandbox != null) {
			string += "InputSandbox = {";
			for (String s : inputSandbox) {
				string += "\"" + s + "\", ";
			}

			string = string.substring(0, string.length() - 2);

			string += "};\n";
		}
		if (outputSandbox != null) {
			string += "OutputSandbox = {";
			for (String s : outputSandbox) {
				string += "\"" + s + "\", ";
			}

			string = string.substring(0, string.length() - 2);

			string += "};\n";
		}
		if (outputSandboxDestUri != null) {
			string += "OutputSandboxDestURI = {";
			for (String s : outputSandboxDestUri) {
				string += "\"" + s + "\", ";
			}

			string = string.substring(0, string.length() - 2);

			string += "};\n";
		}
		if (inputData != null) {
			string += "InputData = {";
			for (String s : inputData) {
				string += "\"" + s + "\", ";
			}

			string = string.substring(0, string.length() - 2);

			string += "};\n";
		}
		if (outputSE != null && !outputSE.isEmpty()) {
			string += "OutputSE = \"" + outputSE + "\";\n";
		}
		if (outputData != null) {
			string += "OutputData = {";
			for (List<String> list : outputData) {
				string += "[";
				if (!list.get(0).equals("noData")) {
					string += "OutputFile = " + list.get(0) + "; ";
				}
				if (!list.get(1).equals("noData")) {
					string += "StorageElement = " + list.get(1) + "; ";
				}
				if (!list.get(2).equals("noData")) {
					string += "LogicalFileName = " + list.get(2) + "; ";
				}
				string = string.substring(0, string.length() - 2);
				string += "], ";
			}

			string = string.substring(0, string.length() - 2);

			string += "};\n";
		}
		if (parameters != null) {
			if (parameters.matches("((-|\\+)?[0-9]+(\\.[0-9]+)?)+")) {
				string += "Parameters = " + parameters + ";\n";
				if (parameterStart != null) {
					string += "ParameterStart = " + parameterStart + ";\n";
				}
				if (parameterStep != null) {
					string += "ParameterStep = " + parameterStep + ";\n";
				}
			} else {
				string += "Parameters = {";
				for (String s : parameters.split(";")) {
					string += "\"" + s + "\", ";
				}

				string = string.substring(0, string.length() - 2);

				string += "};\n";
			}
			string += "OutputSE = \"" + outputSE + "\";\n";
		}
		if (cpuNumber != null && !cpuNumber.isEmpty()) {
			string += "CPUNumber = " + cpuNumber + ";\n";
		}
		if (hostNumber != null && !hostNumber.isEmpty()) {
			string += "HostNumber = " + hostNumber + ";\n";
		}
		if (wholeNodes != null && !wholeNodes.isEmpty()) {
			string += "WholeNodes = " + wholeNodes + ";\n";
		}
		if (smpGranularity != null && !smpGranularity.isEmpty()) {
			string += "SMPGranularity = \"" + smpGranularity + "\";\n";
		}

		return string;
	}

	
	public void setParameter(String parameter, Object value) {
		int index = parameterNames.indexOf(parameter);
		switch(index){
		case 0: this.jobName = (String) value; break;
		case 1: this.executable = (String) value; break;
		case 2: this.arguments = (String) value; break;
//		case 3: this.inputSandbox = (List<String>) value; break;
		case 4: this.outputSandboxRequest = (String) value; break;
//		case 5: this.outputSandbox = (List<String>) value; break;
//		case 6: this.outputSandboxDestUri = (List<String>) value; break;
		case 7: this.stdOutput = (String) value; break;
		case 8: this.stdError = (String) value; break;
//		case 9: this.inputData = (List<String>) value; break;
		case 10: this.outputSE = (String) value; break;
//		case 11: this.outputData = (List<List<String>>) value; break;
		case 12: this.outputPath = (String) value; break;
		case 13: this.parameters = (String) value; break;
		case 14: this.parameterStart = (String) value; break;
		case 15: this.parameterStep = (String) value; break;
		case 16: this.cpuNumber = (String) value; break;
		case 17: this.hostNumber = (String) value; System.out.println("hostNumber: " + hostNumber); break;
		case 18: this.wholeNodes = (String) value; System.out.println("wholeNodes: " + wholeNodes); break;
		case 19: this.smpGranularity = (String) value; break;
		case 20: this.vo = (String) value; break;
		
		}
	}

}
