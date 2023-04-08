//
//  SectionExpectation_Tests.swift
//  
//
//  Created by Stefan Ueter on 29.03.23.
//

import Foundation
import CombineTestbox
import Combine
import XCTest
import GeneratedTestCase


class SectionExpectation_Tests: FeatureTestCase
{
    override
    static
    func setUp()
    {
        Testbox.config.debug.state = false
        Testbox.config.reportedEvents = [.receiveValue, .section]
    }
    
    
    @TestBuilder
    override
    static
    func buildTests() -> [Test]
    {
        // MARK: - SIMPLE
        
        category("simple")
        {
            
            // MARK: with section event
            
            category("with section event")
            {
                
                // MARK: matching title
                
                category("matching title")
                {
                    
                    // MARK: matching
                    
                    test(
                        "matching",
                        setup:
                            {
                                testbox, subject, sub in
                                
                                testbox
                                    .section("section1")
                                    {
                                        subject.send(1)
                                    }
                            },
                        expectations:
                            {
                                section("section1")
                                {
                                    "sub" > receiveValue(1)
                                }
                            },
                        expectationsInverse:
                            {
                                section("section1")
                                {
                                    "sub" > receiveValue(1)
                                }
                                !! fulfilledInverse
                            }
                    )

                    
                    // MARK: mismatching
                    
                    test(
                        "mismatching",
                        setup:
                            {
                                testbox, subject, sub in
                                
                                testbox
                                    .section("section1")
                                    {
                                        subject.send(2)
                                    }
                            },
                        expectations:
                            {
                                section("section1")
                                {
                                    "sub" > receiveValue(1)     !! unfulfilled
                                }
                            },
                        expectationsInverse:
                            {
                                section("section1")
                                {
                                    "sub" > receiveValue(1)
                                }
                            }
                    )
                }
                
                
                // MARK: mismatching title
                
                category("mismatching title")
                {
                    
                    // MARK: matching
                    
                    test(
                        "matching",
                        setup:
                            {
                                testbox, subject, sub in
                                
                                testbox
                                    .section("section2")
                                    {
                                        subject.send(1)
                                    }
                            },
                        expectations:
                            {
                                section("section1")
                                {
                                    "sub" > receiveValue(1)
                                }
                                !! unfulfilled
                            },
                        expectationsInverse:
                            {
                                section("section1")
                                {
                                    "sub" > receiveValue(1)
                                }
                            }
                    )

                    
                    // MARK: mismatching
                    
                    test(
                        "mismatching",
                        setup:
                            {
                                testbox, subject, sub in
                                
                                testbox
                                    .section("section2")
                                    {
                                        subject.send(2)
                                    }
                            },
                        expectations:
                            {
                                section("section1")
                                {
                                    "sub" > receiveValue(1)
                                }
                                !! unfulfilled
                            },
                        expectationsInverse:
                            {
                                section("section1")
                                {
                                    "sub" > receiveValue(1)
                                }
                            }
                    )
                }
            }
            
            
            // MARK: without section event
            
            category("without section event")
            {
                
                // MARK: matching
                
                test(
                    "matching",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                        },
                    expectations:
                        {
                            section("section1")
                            {
                                "sub" > receiveValue(1)
                            }
                            !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            section("section1")
                            {
                                "sub" > receiveValue(1)
                            }
                        }
                )

                
                // MARK: mismatching
                
                test(
                    "mismatching",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(2)
                        },
                    expectations:
                        {
                            section("section1")
                            {
                                "sub" > receiveValue(1)
                            }
                            !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            section("section1")
                            {
                                "sub" > receiveValue(1)
                            }
                        }
                )
            }
            
            
            // MARK: unexpected section
            
            category("unexpected section")
            {
                
                // MARK: matching
                
                test(
                    "matching",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            testbox.section("section1")
                            {
                                subject.send(1)
                            }
                        },
                    expectations:
                        {
                            /*
                             section events are ignored
                             */
                            
                            "sub" > receiveValue(1)
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveValue(1)     !! fulfilledInverse
                        }
                )

                
                // MARK: mismatching
                
                test(
                    "mismatching",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            testbox.section("section1")
                            {
                                subject.send(2)
                            }
                        },
                    expectations:
                        {
                            "sub" > receiveValue(1)     !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveValue(1)
                        }
                )

                
                // MARK: with nested structure
                
                category("with nested structure")
                {
                    
                    // MARK: matching
                    
                    test(
                        "matching",
                        setup:
                            {
                                testbox, subject, sub in
                                
                                testbox.section("section1")
                                {
                                    subject.send(1)
                                }
                            },
                        expectations:
                            {
                                group
                                {
                                    group
                                    {
                                        "sub" > receiveValue(1)
                                    }
                                }
                            },
                        expectationsInverse:
                            {
                                group
                                {
                                    group
                                    {
                                        "sub" > receiveValue(1)
                                    }
                                }
                                !! fulfilledInverse
                            }
                    )

                    
                    // MARK: mismatching
                    
                    test(
                        "mismatching",
                        setup:
                            {
                                testbox, subject, sub in
                                
                                testbox.section("section1")
                                {
                                    subject.send(2)
                                }
                            },
                        expectations:
                            {
                                group
                                {
                                    group
                                    {
                                        "sub" > receiveValue(1)     !! unfulfilled
                                    }
                                }
                            },
                        expectationsInverse:
                            {
                                group
                                {
                                    group
                                    {
                                        "sub" > receiveValue(1)
                                    }
                                }
                            }
                    )
                }
            }
        }
        
        
        // MARK: - WITH STRICT
        
        category("with strict")
        {
            
            // MARK: matching
            
            test(
                "matching",
                setup:
                    {
                        testbox, subject, sub in
                        
                        testbox.section("section")
                        {
                            subject.send(1)
                        }
                    },
                expectations:
                    {
                        section("section")
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)
                            }
                        }
                    },
                expectationsInverse:
                    {
                        section("section")
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)
                            }
                        }
                        !! fulfilledInverse
                    }
            )

            
            // MARK: mismatching
            
            test(
                "mismatching",
                setup:
                    {
                        testbox, subject, sub in
                        
                        testbox.section("section")
                        {
                            subject.send(2)
                        }
                    },
                expectations:
                    {
                        section("section")
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)     !! mismatching .. "sub" > receiveValue(2)
                            }
                        }
                    },
                expectationsInverse:
                    {
                        section("section")
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)     !! mismatching .. "sub" > receiveValue(2)
                            }
                        }
                    }
            )

            
            // MARK: unexpected
            
            test(
                "unexpected",
                setup:
                    {
                        testbox, subject, sub in
                        
                        testbox.section("section")
                        {
                            subject.send(1)
                            subject.send(2)
                        }
                    },
                expectations:
                    {
                        section("section")
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)
                            }
                            !! unexpected .. "sub" > receiveValue(2)
                        }
                    },
                expectationsInverse:
                    {
                        section("section")
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)
                            }
                            !! unexpected .. "sub" > receiveValue(2)
                        }
                    }
            )
        }
        
        
        // MARK: - INSIDE STRICT
        
        category("inside strict")
        {
            
            // MARK: with section strictness
            
            category("with section strictness")
            {
                
                // MARK: matching title
                
                test(
                    "matching title",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            testbox.section("section")
                            {
                                subject.send(1)
                            }
                        },
                    expectations:
                        {
                            strict(.section)
                            {
                                section("section")
                                {
                                    "sub" > receiveValue(1)
                                }
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.section)
                            {
                                section("section")
                                {
                                    "sub" > receiveValue(1)
                                }
                            }
                            !! fulfilledInverse
                        }
                )

                
                // MARK: mismatching title

                test(
                    "mismatching title",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            testbox.section("_wrong_")
                            {
                                subject.send(1)
                            }
                        },
                    expectations:
                        {
                            strict(.section)
                            {
                                section("section")
                                {
                                    "sub" > receiveValue(1)
                                }
                                !! mismatching .. sectionOpen("_wrong_")
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.section)
                            {
                                section("section")
                                {
                                    "sub" > receiveValue(1)
                                }
                                !! mismatching .. sectionOpen("_wrong_")
                            }
                        }
                )

                
                // MARK: unexpected section

                test(
                    "unexpected section",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            testbox.section("section")
                            {
                                subject.send(1)
                            }
                        },
                    expectations:
                        {
                            strict(.section)
                            {
                                "sub" > receiveValue(1)     !! unexpected .. sectionOpen("section")
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.section)
                            {
                                "sub" > receiveValue(1)     !! unexpected .. sectionOpen("section")
                            }
                        }
                )
            }
            

            // MARK: without section strictness
            
            category("without section strictness")
            {
                
                // MARK: matching title
                
                test(
                    "matching title",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            testbox.section("section")
                            {
                                subject.send(1)
                            }
                        },
                    expectations:
                        {
                            strict(.none)
                            {
                                section("section")
                                {
                                    "sub" > receiveValue(1)
                                }
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.none)
                            {
                                section("section")
                                {
                                    "sub" > receiveValue(1)
                                }
                            }
                            !! fulfilledInverse
                        }
                )

                
                // MARK: mismatching title

                test(
                    "mismatching title",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            testbox.section("_wrong_")
                            {
                                subject.send(1)
                            }
                        },
                    expectations:
                        {
                            strict(.none)
                            {
                                section("section")
                                {
                                    "sub" > receiveValue(1)
                                }
                                !! unfulfilled
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.none)
                            {
                                section("section")
                                {
                                    "sub" > receiveValue(1)
                                }
                            }
                        }
                )

                
                // MARK: unexpected section

                test(
                    "unexpected section",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            testbox.section("section")
                            {
                                subject.send(1)
                            }
                        },
                    expectations:
                        {
                            strict(.none)
                            {
                                "sub" > receiveValue(1)
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.none)
                            {
                                "sub" > receiveValue(1)
                            }
                            !! fulfilledInverse
                        }
                )
            }
            
            
            // MARK: unexpected strict event
            
            test(
                "unexpected strict event",
                setup:
                    {
                        testbox, subject, sub in
                        
                        testbox.section("section")
                        {
                            subject.send(1)
                            subject.send(2)     // unexpected
                        }
                    },
                expectations:
                    {
                        strict(.receiveValue)
                        {
                            section("section")
                            {
                                "sub" > receiveValue(1)
                            }
                            !! unexpected .. "sub" > receiveValue(2)
                        }
                    },
                expectationsInverse:
                    {
                        strict(.receiveValue)
                        {
                            section("section")
                            {
                                "sub" > receiveValue(1)
                            }
                            !! unexpected .. "sub" > receiveValue(2)
                        }
                    }
            )
        }
        
        
        // MARK: -  NESTED SECTIONS
        
        category("nested sections")
        {
            
            // MARK: different titles
            
            category("different titles")
            {
                
                // MARK: matching titles
                
                test(
                    "matching titles",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            testbox.section("outer")
                            {
                                testbox.section("inner")
                                {
                                    subject.send(1)
                                }
                            }
                        },
                    expectations:
                        {
                            section("outer")
                            {
                                section("inner")
                                {
                                    "sub" > receiveValue(1)
                                }
                            }
                        },
                    expectationsInverse:
                        {
                            section("outer")
                            {
                                section("inner")
                                {
                                    "sub" > receiveValue(1)
                                }
                            }
                            !! fulfilledInverse
                        }
                )

                
                // MARK: mismatching inner title
                
                test(
                    "mismatching inner title",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            testbox.section("outer")
                            {
                                testbox.section("_wrong_")
                                {
                                    subject.send(1)
                                }
                            }
                        },
                    expectations:
                        {
                            section("outer")
                            {
                                section("inner")
                                {
                                    "sub" > receiveValue(1)
                                }
                                !! unfulfilled
                            }
                        },
                    expectationsInverse:
                        {
                            section("outer")
                            {
                                section("inner")
                                {
                                    "sub" > receiveValue(1)
                                }
                            }
                        }
                )
            }

            
            // MARK: same titles
            
            category("same titles")
            {
                
                // MARK: matching titles
                
                test(
                    "matching titles",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            testbox.section("section")
                            {
                                testbox.section("section")
                                {
                                    subject.send(1)
                                }
                            }
                        },
                    expectations:
                        {
                            section("section")
                            {
                                section("section")
                                {
                                    "sub" > receiveValue(1)
                                }
                            }
                        },
                    expectationsInverse:
                        {
                            section("section")
                            {
                                section("section")
                                {
                                    "sub" > receiveValue(1)
                                }
                            }
                            !! fulfilledInverse
                        }
                )

                
                // MARK: mismatching inner title
                
                test(
                    "mismatching inner title",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            testbox.section("section")
                            {
                                testbox.section("_wrong_")
                                {
                                    subject.send(1)
                                }
                            }
                        },
                    expectations:
                        {
                            section("section")
                            {
                                section("section")
                                {
                                    "sub" > receiveValue(1)
                                }
                                !! unfulfilled
                            }
                        },
                    expectationsInverse:
                        {
                            section("section")
                            {
                                section("section")
                                {
                                    "sub" > receiveValue(1)
                                }
                            }
                        }
                )
            }
        }
        
        
        // MARK: - SPECIAL
        
        category("special")
        {
            
            // MARK: escaping section
            
            /*
             events must never "escape" a section through successor testing.
             thus, sections do not have successors.
             
             in this example, strict would normally test value (2) with its successor, but it would be outside its section, so it does not happen.
             */
            
            test(
                "escaping section",
                setup:
                    {
                        testbox, subject, sub in
                        
                        testbox
                            .section("section1")
                        {
                            subject.send(1)
                            subject.send(2)
                        }
                        .section("section2")
                        {
                        }
                    },
                expectations:
                    {
                        /*
                         value (2) is not tested in the combine expectation in section 2 (possible successor), but does instead lead to a failure in the section 1's strict.
                         */
                        
                        section("section1")
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)
                            }
                            !! unexpected { "sub" > receiveValue(2) }
                        }
                        
                        section("section2")
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(2)
                            }
                        }
                    },
                expectationsInverse:
                    {
                        section("section1")
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)
                            }
                            !! unexpected { "sub" > receiveValue(2) }
                        }
                        
                        section("section2")
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(2)
                            }
                        }
                    }
            )
        }
    }
}
