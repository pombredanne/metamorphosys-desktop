﻿namespace CyPhyMasterInterpreter
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;

    /// <summary>
    /// Represents errors that occur during a given model gets expanded/elaborated to another one.
    /// </summary>
    /// <remarks>
    /// For instance a design space test bench is given and it gets expanded to a test bench that
    /// points to a single configuration and errors occur during that process.
    /// </remarks>
    [Serializable]
    public class AnalysisModelExpandFailedException : AnalysisModelProcessorException
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="AnalysisModelExpandFailedException"/> class.
        /// </summary>
        public AnalysisModelExpandFailedException()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="AnalysisModelExpandFailedException"/> class with a specified
        /// error message.
        /// </summary>
        /// <param name="message">The message that describes the error.</param>
        public AnalysisModelExpandFailedException(string message)
            : base(message)
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="AnalysisModelExpandFailedException"/> class with a specified
        /// error message and a reference to the inner exception that is the cause of
        /// this exception.
        /// </summary>
        /// <param name="message">The error message that explains the reason for the exception.</param>
        /// <param name="inner">The exception that is the cause of the current exception, or a null reference
        /// (Nothing in Visual Basic) if no inner exception is specified.</param>
        public AnalysisModelExpandFailedException(string message, Exception inner)
            : base(message, inner)
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="AnalysisModelExpandFailedException"/> class with serialized
        /// data.
        /// </summary>
        /// <param name="info">The System.Runtime.Serialization.SerializationInfo that holds the serialized
        /// object data about the exception being thrown.</param>
        /// <param name="context">The System.Runtime.Serialization.StreamingContext that contains contextual
        /// information about the source or destination.</param>
        protected AnalysisModelExpandFailedException(
          System.Runtime.Serialization.SerializationInfo info,
          System.Runtime.Serialization.StreamingContext context)
            : base(info, context)
        {
        }
    }
}
