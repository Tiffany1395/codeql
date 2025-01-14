/**
 * @name Hard-coded encryption key
 * @description The .Key property or rgbKey parameter of a SymmetricAlgorithm should never be a hard-coded value.
 * @kind problem
 * @id cs/hardcoded-key
 * @problem.severity error
 * @security-severity 8.1
 * @tags security
 *       external/cwe/cwe-320
 */

/*
 * consider: @precision high
 */

import csharp
import semmle.code.csharp.security.cryptography.EncryptionKeyDataFlowQuery

/**
 * The creation of a literal byte array.
 */
class ByteArrayLiteralSource extends KeySource {
  ByteArrayLiteralSource() {
    this.asExpr() =
      any(ArrayCreation ac |
        ac.getArrayType().getElementType() instanceof ByteType and
        ac.hasInitializer()
      )
  }
}

/**
 * Any string literal as a source
 */
class StringLiteralSource extends KeySource {
  StringLiteralSource() { this.asExpr() instanceof StringLiteral }
}

from SymmetricKeyTaintTrackingConfiguration keyFlow, KeySource src, SymmetricEncryptionKeySink sink
where keyFlow.hasFlow(src, sink)
select sink, "This hard-coded $@ is used in symmetric algorithm in " + sink.getDescription(), src,
  "symmetric key"
