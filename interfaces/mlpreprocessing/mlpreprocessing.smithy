// mlpreprocessing.smithy
//

// Tell the code generator how to reference symbols defined in this namespace
metadata package = [ { namespace: "com.example.interfaces.mlpreprocessing", crate: "test" } ]

namespace com.example.interfaces.mlpreprocessing

use org.wasmcloud.model#codegenRust
use org.wasmcloud.model#wasmbus
use org.wasmcloud.model#n
use org.wasmcloud.model#U8
use org.wasmcloud.model#U16
use org.wasmcloud.model#U32
use org.wasmcloud.model#U64
use org.wasmcloud.model#F32
use org.wasmcloud.model#I32
use org.wasmcloud.model#Unit

/// Description of Mlpreprocessing service
@wasmbus( actorReceive: true )
service MlPreprocessing {
  version: "0.1",
  operations: [ Convert ]
}

/// Converts the input string to a result
operation Convert {
  input: ConversionRequest,
  output: ConversionOutput
}

/// ConversionRequest
//@codegenRust(noDeriveDefault: true, noDeriveEq: true)
structure ConversionRequest {
  @required
  @n(0)
  data: Blob,

  // @n(1)
  // toType: TensorType,

  // @n(2)
  // toShape: TensorDimensions,
}

/// ConversionOutput
//@codegenRust(noDeriveDefault:true)
structure ConversionOutput {

    @required
    @n(0)
    result: Status,

    @required
    @n(1)
    tensor: Tensor
}

/// Response is either success or an error code
union Status {

    @n(0)
    success: Unit,

    @n(1)
    error: MlPError,
}

/// The tensor's dimensions and type are provided as metadata to a model.
/// Any metadata shall be associated to the respective model in a blob store.
@codegenRust(noDeriveDefault:true)
structure Tensor {
    /// Tensor Dimensions
    /// The Dimension array contains one size value for each dimension
    /// of the Tensor
    @required
    @n(0)
    dimensions: Dimensions,

    /// The types array contains either: a single ValueType
    /// that represents the data values for all dimensions (homogeneous array)
    /// or one ValueType per dimension. In other words, the length
    /// of this array is either 1 or the length of `dimensions`.
    @required
    @n(1)
    valueTypes: ValueTypes,

    /// Optional bit flags representing the data representation in the Tensor.
    /// Currently only one bit (LSB) is used to indicate
    /// row-major order (0) or column-major order (1).
    @required
    @n(2)
    flags: u8,

    /// The Tensor 
    @required
    @n(3)
    data: Blob
}

list Dimensions {
    member: U32
}

list ValueTypes {
    member: ValueType
}

/// Value of a data element in a tensor
union ValueType {

    /// Unsigned 8-bit data (0x00) (b0000 0000)
    @n(0)
    valueU8: Unit,

    /// Unsigned 16-bit data (0x01) (b0000 0001)
    @n(1)
    valueU16: Unit,

    /// Unsigned 32-bit data (0x02) (b0000 0010)
    @n(2)
    valueU32: Unit,

    /// Unsigned 64-bit data (0x03) (b0000 0011)
    @n(3)
    valueU64: Unit,

    /// Unsigned 128-bit data (0x04) (b0000 0100)
    @n(4)
    valueU128: Unit,

    /// Signed 8-bit data (0x40) (b0100 0000)
    @n(64)
    valueS8: Unit,

    /// Signed 16-bit data (0x41) (b0100 0001)
    @n(65)
    valueS16: Unit,

    /// Signed 32-bit data (0x42) (b0100 0010)
    @n(66)
    valueS32: Unit,

    /// Signed 64-bit data (0x43) (b0100 0011)
    @n(67)
    valueS64: Unit,

    /// Signed 128-bit data (0x44) (b0100 0100)
    @n(68)
    valueS128: Unit,

    /// 16-bit IEEE Float (0x81) (b1000 0001)
    @n(129)
    valueF16: Unit,

    /// 32-bit IEEE Float (0x82) (b1000 0010)
    @n(130)
    valueF32: Unit,

    /// 64-bit IEEE Float (0x83) (b1000 0011)
    @n(131)
    valueF64: Unit,

    /// 128-bit IEEE Float (0x84) (b1000 0100)
    @n(132)
    valueF128: Unit,
}

/// Error returned with InferenceOutput
union MlPError {
    @n(0)
    runtimeError: String,

    @n(1)
    notSupported: String,
}