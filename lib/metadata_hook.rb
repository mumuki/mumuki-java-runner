class JavaMetadataHook < Mumukit::Hook
  def metadata
    {language: {
        name: 'java',
        icon: {type: 'devicon', name: 'java'},
        version: 'openjdk-8',
        extension: 'java',
        ace_mode: 'java'
    },
     test_framework: {
         name: 'junit',
         version: '4.12',
         test_extension: 'java',
         template: <<java
@Test
public void testDescriptionExample() {
  Assert.assertTrue(true);
}
java
     }}
  end
end