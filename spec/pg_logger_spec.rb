require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module PG
  module Result
    PG_DIAG_SEVERITY = :PG_DIAG_SEVERITY
    PG_DIAG_MESSAGE_PRIMARY = :PG_DIAG_MESSAGE_DETAIL
    PG_DIAG_MESSAGE_DETAIL = :PG_DIAG_MESSAGE_DETAIL
    PG_DIAG_MESSAGE_HINT = :PG_DIAG_MESSAGE_HINT
  end
end

describe "PgLogger" do
  it "converts the messages and sends them to the logger" do
    out = StringIO.new
    logger = double('Logger')
    
    proc = PgLogger.notice_proc_for_logger(logger)
    expect(proc).to respond_to(:call)
    
    fake_notice = double('PG::Result')
    expect(fake_notice).to receive(:error_field).with(PG::Result::PG_DIAG_SEVERITY) { 'NOTICE' }
    expect(fake_notice).to receive(:error_field).with(PG::Result::PG_DIAG_MESSAGE_PRIMARY) { 'Something bad happened' }
    expect(fake_notice).to receive(:error_field).with(PG::Result::PG_DIAG_MESSAGE_DETAIL) { 'in a detailed way' }
    expect(fake_notice).to receive(:error_field).with(PG::Result::PG_DIAG_MESSAGE_HINT) { 'may be fixable' }
    
    expect(logger).to receive(:warn) {|&blk|
      expect(blk.call).to eq('[pg] Something bad happened in a detailed way may be fixable')
    }
    
    proc.call(fake_notice)
  end
  
  it "honors the format string" do
    out = StringIO.new
    logger = double('Logger')
    
    proc = PgLogger.notice_proc_for_logger(logger, 'PostgreSQL said %s')
    expect(proc).to respond_to(:call)
    
    fake_notice = double('PG::Result')
    expect(fake_notice).to receive(:error_field).with(PG::Result::PG_DIAG_SEVERITY) { 'NOTICE' }
    expect(fake_notice).to receive(:error_field).with(PG::Result::PG_DIAG_MESSAGE_PRIMARY) { 'Something bad happened' }
    expect(fake_notice).to receive(:error_field).with(PG::Result::PG_DIAG_MESSAGE_DETAIL) { 'in a detailed way' }
    expect(fake_notice).to receive(:error_field).with(PG::Result::PG_DIAG_MESSAGE_HINT) { 'may be fixable' }
    
    expect(logger).to receive(:warn) {|&blk|
      expect(blk.call).to eq('PostgreSQL said Something bad happened in a detailed way may be fixable')
    }
    
    proc.call(fake_notice)
  end
end
